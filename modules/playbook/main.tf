# Trigger ansible playbook
resource "null_resource" "ansible_play" {
  provisioner "remote-exec" {
    inline = [
      "sleep 90",
      ". ~/.bashrc",
      "which ansible-playbook",
      "ansible-playbook --version",
      "ls -la ~/ansible/",
      "cd ~/ansible/",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook -i inventory.ini main.yaml --extra-vars 'domain_name=${var.domain} email=${var.email}'"
    ]
 
    connection {
      type        = "ssh"
      host        = var.ansible_controller.public_ip
      user        = "ubuntu"
      private_key = var.tls_key
    }
  }
}
