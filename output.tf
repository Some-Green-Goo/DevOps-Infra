output "instance_public_ip" {
  value = aws_instance.infra.public_ip
}

output "dns_name" {
  value = aws_route53_record.site_domain.name
}
