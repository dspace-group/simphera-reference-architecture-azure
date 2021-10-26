resource "azurerm_resource_group" "bastion" {
  count    = var.licenseServer ? 1 : 0
  name     = "${var.infrastructurename}-bastion"
  location = var.location

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_subnet" "bastion-subnet" {
  count                = var.licenseServer ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.96.0/24"]
}

resource "azurerm_public_ip" "bastion-pubip" {
  count               = var.licenseServer ? 1 : 0
  name                = "bastion-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_bastion_host" "bastion-host" {
  count               = var.licenseServer ? 1 : 0
  name                = "bastion-host"
  location            = var.location
  resource_group_name = azurerm_resource_group.bastion.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pubip.0.id
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
