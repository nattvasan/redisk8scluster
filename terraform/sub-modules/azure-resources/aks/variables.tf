variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "system_nodepool_name" {
  type = string
}

variable "system_nodepool_node_max_count" {
  type = number
}

variable "system_nodepool_node_min_count" {
  type = number
}

variable "system_nodepool_node_tier" {
  type = string
}

variable "user_nodepool1_name" {
  type = string
}

variable "user_nodepool1_node_max_count" {
  type = number
}

variable "user_nodepool1_node_min_count" {
  type = number
}

variable "user_nodepool1_node_tier" {
  type = string
}


variable "resource_group_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "admin_username" {
  type = string
}
