data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "tls_private_key" "ssh" {
  count = var.admin_username == null ? 0 : 1

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "aks" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.cluster_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  tags = var.tags
  role_based_access_control_enabled = true
  image_cleaner_enabled = false
  kubernetes_version    = var.kubernetes_version
  default_node_pool {
    name                         = var.system_nodepool_name
    only_critical_addons_enabled = true
    vm_size                      = var.system_nodepool_node_tier
    type                         = "VirtualMachineScaleSets"
    tags                         = var.tags
    enable_auto_scaling          = true
    zones                        = [1, 2, 3]
    os_disk_size_gb              = 30
    min_count                    = var.system_nodepool_node_min_count
    max_count                    = var.system_nodepool_node_max_count
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []

    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  open_service_mesh_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = var.user_nodepool1_name
  vm_size               = var.user_nodepool1_node_tier
  mode                  = "User"
  os_disk_type          = "Managed"
  zones                 = []
  enable_auto_scaling   = true
  min_count             = var.user_nodepool1_node_min_count
  max_count             = var.user_nodepool1_node_max_count
  tags                  = var.tags

}

resource "null_resource" "read_cluster_info" {
  provisioner "local-exec" {
    command = format("az aks get-credentials --resource-group %s --name %s --overwrite-existing && kubectl config use-context %s", var.resource_group_name, var.cluster_name, var.cluster_name)
  }

  depends_on = [ 
   azurerm_kubernetes_cluster.aks, 
  ]
}
