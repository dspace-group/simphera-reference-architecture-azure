resource "azurerm_resource_group" "network" {
  provider = azurerm.cluster-provider-subscription
  name     = "${var.infrastructurename}-network"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "simphera-vnet" {
  provider            = azurerm.cluster-provider-subscription
  name                = "simphera-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = ["10.0.0.0/17"]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_subnet" "paas-services-subnet" {
  provider                                       = azurerm.cluster-provider-subscription
  name                                           = "paas-services-subnet"
  resource_group_name                            = azurerm_resource_group.network.name
  virtual_network_name                           = azurerm_virtual_network.simphera-vnet.name
  address_prefixes                               = ["10.0.97.0/24"]
  enforce_private_link_endpoint_network_policies = true
}
