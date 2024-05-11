data "azuread_client_config" "current" {}

resource "azuread_application" "main" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "main" {
  client_id                    = azuread_application.main.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
  description                  = var.description
}

resource "time_rotating" "main" {
  rotation_days = var.password_rotation_in_days
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id
  rotate_when_changed = {
    rotation = time_rotating.main.id
  }
}