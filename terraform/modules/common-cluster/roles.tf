resource "azurerm_role_assignment" "role_sp_reader" {
  scope                = format("/subscriptions/%s", var.subscription_id)
  role_definition_name = "Key Vault Reader"
  principal_id         = module.serviceprincipal.service_principal_object_id
  depends_on = [
    module.serviceprincipal,
    module.keyvault
  ]
}

resource "azurerm_role_assignment" "contributor" {
  scope = format("/subscriptions/%s", var.subscription_id)
  role_definition_name = "Contributor"
  principal_id = module.serviceprincipal.service_principal_object_id

  depends_on = [ 
    module.serviceprincipal,
  ]
}

resource "azurerm_role_assignment" "owner" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.resource_group_name)
  role_definition_name = "Owner"
  principal_id         = module.serviceprincipal.service_principal_object_id

  depends_on = [
    module.serviceprincipal,
    azurerm_resource_group.rg
  ]
}

resource "azurerm_role_assignment" "key_vault_admin" {
  scope = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.resource_group_name)
  role_definition_name = "Contributor"
  principal_id = data.azurerm_client_config.current.object_id

  depends_on = [ 
    module.serviceprincipal,
    azurerm_resource_group.rg
   ]
}





