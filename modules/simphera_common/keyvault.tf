resource "azurerm_private_endpoint" "keyvault-private-endpoint" {
  name                = "keyvault-private-endpoint"
  location            = var.location
  resource_group_name = var.keyVaultResourceGroup
  subnet_id           = azurerm_subnet.paas-services-subnet.id

  private_dns_zone_group {
    name                 = "keyvault-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault-privatelink-dns-zone.id]
  }

  private_service_connection {
    name                           = "simphera-keyvault"
    private_connection_resource_id = data.azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone" "keyvault-privatelink-dns-zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
