data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  soft_delete_retention_days = 30
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  tags                       = var.tags
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = var.service_principal_name
  value        = var.service_principal_client_secret
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [
    azurerm_key_vault.key_vault
  ]
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "fc6f991f-c024-434b-b34a-9fd62a265463" 
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}