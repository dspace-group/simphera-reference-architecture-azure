
data "azurerm_virtual_network" "simphera-vnet" {
  provider            = azurerm.cluster-provider-subscription
  name                = "simphera-vnet"
  resource_group_name = "${var.infrastructurename}-network"
}

data "azurerm_subnet" "paas-services-subnet" {
  provider             = azurerm.cluster-provider-subscription
  name                 = "paas-services-subnet"
  resource_group_name  = "${var.infrastructurename}-network"
  virtual_network_name = data.azurerm_virtual_network.simphera-vnet.name
}
