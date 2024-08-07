output "instance_public_ip" {
  value = module.web.instance_public_ip
}

output "dns_name" {
  value = aws_route53_record.site_domain.name
}