# Render Ansible inventory template with private IPs
data "template_file" "ansible_inventory" {
  template = file("${path.module}/../../templates/inventory.tpl")
  vars = {
    private_ips = join(",", var.private_ips)
  }
}

# Write the rendered inventory content to a file
resource "local_file" "inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/../../ansible/inventory.ini"
}

# Copy Ansible configurations to the Ansible controller
resource "null_resource" "copy_ansible" {
  provisioner "file" {
    source      = "${path.module}/../../ansible"
    destination = "/home/ubuntu/ansible/"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.tls_key
      host        = var.ansible_controller.public_ip
    }
  }
  depends_on = [ var.ansible_controller ]
}

# Copy Application dependencies to the Ansible controller
resource "null_resource" "copy_deps" {
  provisioner "file" {
    source      = "${path.module}/../../dependencies"
    destination = "/home/ubuntu/ansible/dependencies/"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.tls_key
      host        = var.ansible_controller.public_ip
    }
  }
  depends_on = [ var.ansible_controller , null_resource.copy_ansible]
}
