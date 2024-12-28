# Application Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow TLS traffic inbound and all outbound"
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags
}

# Allow SSH access from Ansible Controller to Application
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_ansible" {
  security_group_id          = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.ansible_sg.id
  from_port                  = 22
  to_port                    = 22
  ip_protocol                = "tcp"
}

# Allow inbound TLS traffic (ports from the variable `inbound_ports`) to Application
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each          = { for idx, port in var.inbound_ports : idx => port }  # Iterate over ports
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
}

# Allow all outbound traffic from the Application security group
resource "aws_vpc_security_group_egress_rule" "app_allow_all_outbound" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"   # Allow outbound to all destinations
  ip_protocol       = "-1"           # Allow all protocols
}

# Ansible Security Group
resource "aws_security_group" "ansible_sg" {
  name        = "ansible_sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags
}

# Allow inbound SSH traffic to the Ansible Controller
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # Allow SSH from any source
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow outbound SSH traffic from Ansible Controller to Application
resource "aws_vpc_security_group_egress_rule" "ansible_to_app" {
  security_group_id          = aws_security_group.ansible_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                  = 22
  to_port                    = 22
  ip_protocol                = "tcp"
}

# Allow outbound internet access from Ansible Controller
resource "aws_vpc_security_group_egress_rule" "ansible_to_internet" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # Allow access to all external IPs
  ip_protocol       = "-1"          # Allow all protocols
}
