resource "aws_route53_record" "dns" {
  zone_id = var.hosted_zone_id
  name    = "${var.app_name}-${var.env_id}.${var.domain}"
  type    = "CNAME"
  ttl     = 60
  records = [var.alb_dns_name]
}
