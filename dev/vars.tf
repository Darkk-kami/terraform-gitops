variable "aws_region" {
  default = "us-east-1"
}

variable "domain" {
  description = "Domain must match your route53 hosted zone"
}


variable "email" {
  description = "This the email certbot will use to create SSL certificates"
}