data "aws_route53_zone" "selected_zone" {
  name         = var.domain
}

resource "aws_route53_record" "A_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "300"
  records = [var.app_instance[0].public_ip]
}

resource "aws_route53_record" "wildcard_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = "*.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [var.app_instance[0].public_ip]
}
