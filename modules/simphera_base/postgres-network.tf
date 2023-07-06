resource "azurerm_private_dns_zone" "postgresql-privatelink-dns-zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql-privatelink-network-link" {
  name                  = "postgresql-privatelink-network-link"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql-privatelink-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.simphera-vnet.id
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_subnet" "postgresql-server-subnet" {
  name                 = "postgresql-server-subnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.99.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
    }
  }
}
