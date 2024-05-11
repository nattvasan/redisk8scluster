variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
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


variable "argocd_rollout_chart_version" {
  type = string
}

variable "keep_crds" {
  type = bool
}