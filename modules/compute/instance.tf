# Fetch the latest Ubuntu AMI based on specified version
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-${var.distro_version}-amd64-server-*"]
  }

  owners = ["099720109477"]  # Ubuntu's official AWS account ID
}

# EC2 instance for application
resource "aws_instance" "app_instance" {
  count = var.instance_count  

  instance_type          =  var.instance_type
  iam_instance_profile   = var.instance_profile.id
  ami                   = data.aws_ami.ubuntu.id
  subnet_id             = var.subnet_id[count.index % length(var.subnet_id)]
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.private_key.id

  user_data = <<-EOT
    #!/bin/bash
    sudo apt update -y
  EOT
}

# EC2 instance for Ansible controller
resource "aws_instance" "ansible_controller" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id
  subnet_id = var.subnet_id[0]
  vpc_security_group_ids = [var.ansible_controller-sg]
  key_name = var.private_key.id
  
  # User script to install ansible along with directory creation
  user_data = <<-EOT
    #!/bin/bash
    set -e 
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    sudo mkdir -p /etc/ansible/roles /home/ubuntu/ansible/dependencies
    sudo chown -R ubuntu:ubuntu /home/ubuntu/ansible
    sudo ansible-galaxy install --roles-path=/etc/ansible/roles/ bsmeding.docker
  EOT

  tags = {
    Name = "ansible-controller"
  }
}

# Copy SSH key to Ansible controller and set permissions
resource "null_resource" "copy_ssh_key" {
  provisioner "file" {
    content     = var.tls_key
    destination = "/home/ubuntu/.ssh/ansible.pem"

    connection {
      type        = "ssh"
      host        = aws_instance.ansible_controller.public_ip
      user        = "ubuntu"
      private_key = var.tls_key
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/.ssh/ansible.pem"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.ansible_controller.public_ip
      user        = "ubuntu"
      private_key = var.tls_key
    }
  }

  depends_on = [ aws_instance.ansible_controller ]
}
