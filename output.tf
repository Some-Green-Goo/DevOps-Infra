output "web_instance_public_ip" {
  value = module.web.instance_public_ip
}

output "web_instance_private_ip" {
  value = module.web.instance_private_ip
}

output "web_dns_name" {
  value = aws_route53_record.site_domain.name
}