locals {
  playbook_names = ["filebrowser", "nginx"]

  playbooks = {
    for name in local.playbook_names : name => {
      playbook = "ansible/${name}.yml"
      vars = {
        for key, value in local.playbook_vars[name] : key => value
      }
    }
  }
  ingress_ports = [22, 80, 443]
}

resource "aws_instance" "web" {
  ami           = "ami-08f7b2cb6f6b78c21"
  instance_type = "t3a.small"
  subnet_id     = aws_subnet.infra_public.id
  availability_zone  = "us-east-2a"
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name = aws_key_pair.infra.key_name
  root_block_device {
    volume_size = 10
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

      connection {
        type = "ssh"
        user = local.remote_user
        private_key = file(local.private_key_path)
        host = aws_instance.web.public_ip
      }
  }

tags = var.tags
}

resource "aws_security_group" "web" {
  name        = "allow_web"
  description = "Allow SSH and web inbound traffic"
  vpc_id      = aws_vpc.infra.id

  dynamic "ingress" {
    for_each = toset(local.ingress_ports)
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
  name      = aws_instance.web.public_ip
  verbosity = 1
  extra_vars = {
    hostname = local.hostname
  }
  replayable = false
}

resource "ansible_playbook" "configure" {
  for_each = local.playbooks
  playbook  = each.value.playbook
  name      = aws_instance.web.public_ip
  verbosity = 1
  replayable = true
  extra_vars = each.value.vars
  depends_on = [ansible_playbook.vm_setup]
}