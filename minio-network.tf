resource "azurerm_private_dns_zone" "minio-privatelink-dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "minio-privatelink-network-link" {
  name                  = "minio-privatelink-network-link"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.minio-privatelink-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.simphera-vnet.id
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
