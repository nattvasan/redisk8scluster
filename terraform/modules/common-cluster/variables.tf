variable "key_vault_name" {
  type    = string
  default = null
}

variable "vault_private_endpoint_name" {
  type    = string
  default = null

}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "kubernetes_resources_subnet_id" {
  type    = string
  default = null
}

variable "service_principal_name" {
  type = string
}

variable "create_resource_group" {
  type = bool

}
variable "resource_group_name" {
  type    = string
  default = null
}

variable "location" {
  type = string
}

variable "password_rotation_in_days" {
  type = string
}

variable "subscription_id" {
  type = string
}
# variable "service_principal_client_id" {
#   description = "Client ID of the service principal."
# }

# variable "service_principal_client_secret" {
#   description = "Client secret of the service principal."
# }

variable "admin_username" {
  type = string
}

# variable "public_ssh_key" {
#   type        = string
#   default     = ""
#   description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
# }

variable "system_nodepool_name" {
  type = string
}

# variable "system-nodepool-node-count" {
#   type = number
# }

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

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "config_path" {
  type = string
}

variable "argo_helm_chart_version" {
  type = string
}


variable "argocd_apps_chart_version" {
  type = string
}


variable "install_crds" {
  type = bool
}

variable "keep_crds" {
  type = bool
}

variable "resource_group_name_hub" {
  type    = string
  default = null
}

variable "argocd_rollout_chart_version" {
  type = string
}