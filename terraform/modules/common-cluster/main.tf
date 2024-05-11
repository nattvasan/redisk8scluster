data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}


module "serviceprincipal" {
  source                    = "../../sub-modules/azure-resources/serviceprincipal"
  service_principal_name    = var.service_principal_name
  password_rotation_in_days = var.password_rotation_in_days

  depends_on = [azurerm_resource_group.rg]
}

module "keyvault" {
  source                          = "../../sub-modules/azure-resources/keyvault"
  key_vault_name                  = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  service_principal_name          = var.service_principal_name
  service_principal_object_id     = module.serviceprincipal.service_principal_object_id
  service_principal_tenant_id     = module.serviceprincipal.service_principal_tenant_id
  service_principal_client_id     = module.serviceprincipal.client_id
  service_principal_client_secret = module.serviceprincipal.client_secret
  vault_private_endpoint_name     = var.vault_private_endpoint_name
  tags                            = var.tags
  kubernetes_resources_subnet_id  = var.kubernetes_resources_subnet_id
  keyvault_name                   = var.key_vault_name
  password_rotation_in_days       = var.password_rotation_in_days

  depends_on = [
    module.serviceprincipal
  ]
}

module "aks" {
  source       = "../../sub-modules/azure-resources/aks"
  cluster_name = var.cluster_name
  client_id                      = module.serviceprincipal.client_id
  client_secret                  = module.serviceprincipal.client_secret
  location                       = var.location
  resource_group_name            = var.resource_group_name
  system_nodepool_name           = var.system_nodepool_name
  system_nodepool_node_tier      = var.system_nodepool_node_tier
  system_nodepool_node_min_count = var.system_nodepool_node_min_count
  system_nodepool_node_max_count = var.system_nodepool_node_max_count
  user_nodepool1_name            = var.user_nodepool1_name
  user_nodepool1_node_tier       = var.user_nodepool1_node_tier
  user_nodepool1_node_max_count  = var.user_nodepool1_node_max_count
  user_nodepool1_node_min_count  = var.user_nodepool1_node_min_count

  admin_username = var.admin_username
  kubernetes_version = var.kubernetes_version
  tags               = var.tags

  depends_on = [
    module.serviceprincipal,
    module.keyvault
  ]
}

resource "kubernetes_namespace" "redis" {
  metadata {
    name = "redis"
  }
}


module "argocd" {
  providers = {
    azurerm.hub = azurerm.hub
  }
  source                       = "../../sub-modules/kuberenets-resources/argocd"
  config_path                  = var.config_path
  argocd_apps_chart_version    = var.argocd_apps_chart_version
  argo_helm_chart_version      = var.argo_helm_chart_version
  install_crds                 = var.install_crds
  tags                         = var.tags
  argocd_rollout_chart_version = var.argocd_rollout_chart_version
  keep_crds =          var.keep_crds
  depends_on = [
    module.aks,
  ]
}