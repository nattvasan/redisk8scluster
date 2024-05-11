terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.hub]
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}
