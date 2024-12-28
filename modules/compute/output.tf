# Output public IPs of all application instances
output "app_instance_ips" {
  value = [for instance in aws_instance.app_instance : instance.public_ip]
}

# Output private IPs of all application instances, flattening the list
output "app_instance_private_ips" {
  value = flatten([for instance in aws_instance.app_instance : instance.private_ip])
}

# Output the Ansible controller instance details
output "ansible_controller" {
  value = aws_instance.ansible_controller
}

output "app_instance" {
  value = aws_instance.app_instance
}
