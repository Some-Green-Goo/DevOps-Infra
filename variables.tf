variable "tags" {
  description = "Tags to assign to the resource"
  type        = map(string)
  default = {
    Name = "tf-infra"
  }
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "placeholder.xyz"
}

#locals {
# playbook_vars = {
#    filebrowser = {
#    }
#    nginx = {
#    }
#    immich = {
#    }
#  }
#}


