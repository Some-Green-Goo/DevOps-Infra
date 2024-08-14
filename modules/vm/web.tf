locals {
  playbooks = {
    for name in var.playbook_names : name => {
      playbook = "ansible/${name}.yml"
      vars = (
        length(var.playbook_vars) > 0 && contains(keys(var.playbook_vars), name)
      ) ? { for key, value in var.playbook_vars[name] : key => value } : {}
    }
  }
}

resource "aws_instance" "vm" {
  ami           = "ami-08f7b2cb6f6b78c21"
  instance_type = "t3a.small"
  subnet_id     = var.subnet_id
  availability_zone  = "us-east-2a"
  vpc_security_group_ids = [aws_security_group.vm.id]
  key_name = var.key_name
  root_block_device {
    volume_size = 10
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

      connection {
        type = "ssh"
        user = var.remote_user
        private_key = file(var.private_key_path)
        host = aws_instance.vm.public_ip
      }
  }

  tags = var.tags
}

resource "aws_security_group" "vm" {
  name        = "allow_vm"
  description = "Allow SSH and vm inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.ingress_ports)
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

resource "ansible_playbook" "vm_setup" {
  playbook  = "ansible/vm_setup.yml"
  name      = aws_instance.vm.public_ip
  verbosity = 1
  extra_vars = {
    hostname = var.hostname
  }
  replayable = false
}

resource "ansible_playbook" "configure" {
  for_each = local.playbooks
  playbook  = each.value.playbook
  name      = aws_instance.vm.public_ip
  verbosity = 1
  replayable = true
  extra_vars = each.value.vars
  depends_on = [ansible_playbook.vm_setup]
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}