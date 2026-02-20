resource "azurerm_private_dns_zone" "storage_privatelink_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_privatelink_network_link" {
  name                  = "storage_privatelink_network_link"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_privatelink_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.simphera-vnet.id
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
