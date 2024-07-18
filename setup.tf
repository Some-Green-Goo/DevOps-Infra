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

provider "aws" {
  region     = "us-east-2"
}

terraform {
  backend "local" {
    path = "backups/terraform.tfstate"
  }
}

resource "aws_key_pair" "infra" {
  key_name   = "infra-key"
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG16+cJ1puANSmEfQUKgEScvngD/D4QVBey/tigjpfyo ashton@localhost.localdomain"
  public_key = file("~/.ssh/terra-aws.pub")

  tags = var.tags
}

data "template_file" "ansible_cfg" {
  template = file("${path.module}/ansible.cfg.tpl")

  vars = {
    remote_user = local.remote_user
    private_key_path = local.private_key_path
  }
}

resource "local_file" "ansible_cfg" {
  content  = data.template_file.ansible_cfg.rendered
  filename = "${path.module}/ansible.cfg"
}
