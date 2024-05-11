# todo

resource "azurerm_virtual_network" "kubernetes-vnet" {
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  tags                = var.tags
  name                = "kubernetes-vnet"
  address_space       = [var.cluster-vnet-address]
  dns_servers         = [var.firewall-private-ip]

  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}

resource "azurerm_subnet" "cluster-subnet" {
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.kubernetes-vnet.name
  name                 = "cluster-subnet"
  address_prefixes     = [var.cluster-subnet-address-prefix]
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}
