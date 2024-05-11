locals {
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl", "subscription.hcl"), {})
  tenant_id = local.subscription_vars.locals.tenant_id
  subscription_id     = local.subscription_vars.locals.subscription_id
  kubernetes_config_context  = local.subscription_vars.locals.kubernetes_config_context
}


generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1.7.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
  }
}
provider "azurerm" {
  tenant_id = "${local.tenant_id}"
  subscription_id = "${local.subscription_id}"
  storage_use_azuread = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "azurerm" {
  alias           = "hub"
  tenant_id       = "${local.tenant_id}"
  subscription_id = "${local.subscription_id}"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "kubernetes" {
  config_context = "${local.kubernetes_config_context}"
  config_path    = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_context = "${local.kubernetes_config_context}"
    config_path    = "~/.kube/config"
  }
}
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    tenant_id            = "${local.tenant_id}"
    subscription_id      = "${local.subscription_id}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "tf-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.subscription_vars.locals
)
