variable "cluster-vnet-address" {
  type = string
}

variable "cluster-subnet-address-prefix" {
  type = string
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "firewall-private-ip" {
  type = string
}
