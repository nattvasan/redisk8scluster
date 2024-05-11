include "root" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform//modules/common-cluster/"
}

inputs = ({
  ##################################################
  # AKS
  ##################################################
  // kubernetes_version                      = "1.25.6"
  // kubernetes_subnet_name                  = "prod-subnet"
  // cluster_vnet_address                    = "10.86.0.0/16"
  // analytics_workspace_daily_quota         = -1
  // akv_name                                = "vault-production"
    # Service Principal
  service_principal_name = "redis-cluster"
  password_rotation_in_years = 1
  password_rotation_in_days = 365
})