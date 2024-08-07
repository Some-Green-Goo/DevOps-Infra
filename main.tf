locals {
  playbook_names = ["filebrowser", "nginx"]

  playbook_vars = {
    filebrowser = {
      var1 = "value1"
      var2 = "value2"
    }
    nginx = {
      var1 = "value1"
      var2 = "value2"
    }
  }

  ingress_ports = [22, 80, 443]
}

module "web" {
  source           = "./modules/web"
  vpc_id           = aws_vpc.infra.id
  subnet_id        = aws_subnet.infra_public.id
  ingress_ports    = local.ingress_ports
  tags             = var.tags
  key_name         = aws_key_pair.infra.key_name
  remote_user      = local.remote_user
  private_key_path = local.private_key_path
  hostname         = local.hostname
  playbook_names   = local.playbook_names
  playbook_vars    = local.playbook_vars
}