output "app_instance_ip" {
  value = module.compute.app_instance_ips
}

output "app_instance_private_ips" {
  value = module.compute.app_instance_private_ips
}


output "ansible_ip" {
  value = module.compute.ansible_controller.public_ip
}
