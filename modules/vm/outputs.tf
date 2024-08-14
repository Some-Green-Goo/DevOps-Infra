output "instance_public_ip" {
  value = aws_instance.vm.public_ip
}

output "instance_private_ip" {
  value = aws_instance.vm.private_ip
}
