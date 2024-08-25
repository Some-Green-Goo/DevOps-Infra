variable "playbook_names" {
  description = "List of playbook names"
  type        = list(string)
}

variable "playbook_vars" {
  description = "Map of playbook variables"
  type        = map(map(any))
}

variable "vpc_id" {
  description = "The ID of the VPC where the instances will be deployed"
  type        = string
}

variable "ingress_ports" {
  description = "List of ingress ports"
  type        = list(number)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "key_name" {
  description = "Key name for the instances"
  type        = string
}

variable "remote_user" {
  description = "SSH user for connecting to instances"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH"
  type        = string
}

variable "hostname" {
  description = "Hostname for the instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the public subnet where the instances will be deployed"
  type        = string
}

variable "private_dns" {
  description = "The private DNS name for the VM"
  type        = string
  default     = "dns"
}

variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
  default     = "placeholder.xyz"
}
