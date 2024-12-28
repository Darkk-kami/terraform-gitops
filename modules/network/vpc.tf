# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.dns_hostnames
  tags                 = var.tags
}

# Fetch available AZs in the chosen region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# Calculate effective AZs and limit based on the region's available AZs
locals {
  effective_azs = min(var.desired_azs, length(data.aws_availability_zones.available_azs.names)) 
  # Slice the list of AZs to match the desired count
  az_list       = slice(data.aws_availability_zones.available_azs.names, 0, local.effective_azs)
}

# Create public subnets, distributing them across available AZs
resource "aws_subnet" "public_subnets" {
  count                   = var.public_subnets_no
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index) 
  # Ensure subnets are distributed across AZs in a round-robin manner
  availability_zone       = local.az_list[count.index % length(local.az_list)] 
  map_public_ip_on_launch = var.map_public_ip
  tags                    = var.tags
}

# Create an Internet Gateway for external connectivity
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

# Create a public route table and route internet traffic through the gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = var.tags
}

# Associate public subnets with the route table
resource "aws_route_table_association" "public_route_table_association" {
  # Loop through subnets to associate each with the route table
  for_each       = { for idx, subnet in aws_subnet.public_subnets : idx => subnet }
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = each.value.id
}
