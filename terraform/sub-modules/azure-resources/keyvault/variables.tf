variable "keyvault_name" {
  type = string
}

variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "service_principal_name" {
  type = string
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "key_vault_name" {
  type = string
}

variable "vault_private_endpoint_name" {
  type = string
}

variable "kubernetes_resources_subnet_id" {
  type = string
}

variable "password_rotation_in_days" {
  type = string
}

variable "service_principal_client_id" {
  description = "Client ID of the service principal."
}

variable "service_principal_client_secret" {
  description = "Client secret of the service principal."
}