locals {
  db = {
    ingress_ports = [22, 80, 443]
    private_dns = "db"
    playbook_names = ["filebrowser", "nginx"]
    playbook_vars = {
      filebrowser = {
        var1 = "value1"
        var2 = "value2"
      }
      nginx = {
        var3 = "value3"
        var4 = "value4"
      }
    }
  }
}

module "db" {
  source           = "./modules/vm"
  vpc_id           = aws_vpc.infra.id
  subnet_id        = aws_subnet.infra_private.id
  ingress_ports    = local.db.ingress_ports
  tags             = var.tags
  key_name         = aws_key_pair.infra.key_name
  remote_user      = local.remote_user
  private_key_path = local.private_key_path
  hostname         = "db-${local.hostname}"
  playbook_names   = local.db.playbook_names
  playbook_vars    = local.db.playbook_vars
  private_dns      = local.db.private_dns
  domain_name      = local.domain_name
  use_jumphost     = true
}
