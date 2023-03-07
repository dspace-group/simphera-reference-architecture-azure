data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "keyvault" {
  name     = "${var.infrastructurename}-keyvault"
  location = var.location
}

resource "azurerm_key_vault" "simphera-key-vault" {
  name                        = substr(replace(var.infrastructurename, "[^0-9a-Z-]", ""), 0, 24)
  location                    = azurerm_resource_group.keyvault.location
  resource_group_name         = azurerm_resource_group.keyvault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
      "Delete",
      "Update",
      "Purge"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = (var.keyVaultAuthorizedIpRanges == null ? "Allow" : "Deny")
    ip_rules                   = var.keyVaultAuthorizedIpRanges
    virtual_network_subnet_ids = []
  }

  lifecycle {
    ignore_changes = [
      access_policy, # Preventing that manually added access policies get overridden
    ]
  }
}

resource "azurerm_key_vault_key" "azure-disk-encryption" {
  name         = "AzureDiskEncryption"
  key_vault_id = azurerm_key_vault.simphera-key-vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "random_password" "license-server-password" {
  length           = 16
  special          = true
  override_special = "!#$%&*-_=+:?"
}

resource "azurerm_key_vault_secret" "license-server-secret" {
  count        = var.licenseServer ? 1 : 0
  name         = "licenseserver"
  value        = jsonencode({ "username" : "cluster", "password" : random_password.license-server-password.result })
  key_vault_id = azurerm_key_vault.simphera-key-vault.id
}

resource "azurerm_private_endpoint" "keyvault-private-endpoint" {
  name                = "keyvault-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.keyvault.name
  subnet_id           = azurerm_subnet.paas-services-subnet.id

  private_dns_zone_group {
    name                 = "keyvault-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault-privatelink-dns-zone.id]
  }

  private_service_connection {
    name                           = "simphera-keyvault"
    private_connection_resource_id = azurerm_key_vault.simphera-key-vault.id
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

output "key_vault_uri" {
  value = azurerm_key_vault.simphera-key-vault.vault_uri
}

output "key_vault_id" {
  value = azurerm_key_vault.simphera-key-vault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.simphera-key-vault.name
}
