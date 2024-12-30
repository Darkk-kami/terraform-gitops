module "network" {
  source = "../modules/network"
  dns_hostnames = "true"
  public_subnets_no = 3
  desired_azs = 100
  map_public_ip = true
  inbound_ports = [ 80, 443 ]
  tags = {
    env = "dev"
  }
}

module "sshkey" {
  source = "../modules/sshkey"
}

module "compute" {
  source = "../modules/compute"
  distro_version = "22.04"
  security_group_id = module.network.security_group_id
  subnet_id = module.network.subnet_ids
  ansible_controller-sg = module.network.ansible_sg_id
  instance_profile = module.route53.ec2_instance_profile
  instance_type = "t2.medium"
  private_key = module.sshkey.private_key
  tls_key = module.sshkey.tls_key
  environment = "dev"
}

module "ansible" {
  source = "../modules/ansible"
  private_ips = module.compute.app_instance_private_ips
  ansible_controller = module.compute.ansible_controller
  private_key = module.sshkey
  tls_key = module.sshkey.tls_key
  depends_on = [ module.templates, module.compute]
  domain = var.domain
  email = var.email
}

module "templates" {
  source = "../modules/template"
  domain = var.domain
}

module "route53" {
  source = "../modules/route53"
  domain = var.domain
  app_instance = module.compute.app_instance
}

module "trigger_playbook" {
  source = "../modules/playbook"
  domain = var.domain
  email = var.email
  tls_key = module.sshkey.tls_key
  ansible_controller = module.compute.ansible_controller
  depends_on = [ module.ansible, module.route53 ]
}



