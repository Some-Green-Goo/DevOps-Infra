variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Name = "tf-infra"
  }
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


