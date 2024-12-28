# Output the ID of the created VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Output the ID of the application security group
output "security_group_id" {
  value = aws_security_group.app_sg.id
}

# Output a list of IDs for the created public subnets
output "subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

# Output the ID of the Ansible security group
output "ansible_sg_id" {
  value = aws_security_group.ansible_sg.id
}
