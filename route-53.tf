# get hosted zone details
# terraform aws data hosted zone
data "aws_route53_zone" "site_domain" {
  name = local.domain_name
}

resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.site_domain.zone_id
  name    = local.domain_name
  type    = "A"
  ttl     = 300
  records = [module.web.instance_public_ip]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.site_domain.zone_id
  name    = "www.${local.domain_name}"
  type    = "A"
  ttl     = 300
  records = [module.web.instance_public_ip]
}

resource "aws_route53_record" "all" {
  zone_id = data.aws_route53_zone.site_domain.zone_id
  name    = "*.${local.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.domain_name]
}
