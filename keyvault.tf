data "azurerm_client_config" "current" {}

locals {
  keyvaultnametest = "MarioKeyVaultTest"
  keyvaultresourcenametest = "MarioKeyVaultRG"
}

resource "azurerm_resource_group" "key-vault-rg-test" {
  name     = local.keyvaultresourcenametest
  location = var.location
}

resource "azurerm_key_vault" "simphera-key-vault-test" {
  name                        = local.keyvaultnametest
  location                    = azurerm_resource_group.key-vault-rg-test.location
  resource_group_name         = azurerm_resource_group.key-vault-rg-test.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

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

    storage_permissions = [
      "Get",
      "Delete",
      "List",
      "Purge",
      "Set",
      "Update"
    ]

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "List",
      "ListIssuers",
      "SetIssuers",
      "Update",
    ]
  }

  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules = ["31.147.185.194"]
    virtual_network_subnet_ids =[]
  }
}

resource "azurerm_key_vault_key" "azure-disk-encryption-test" {
  name         = "AzureDiskEncryption"
  key_vault_id = azurerm_key_vault.simphera-key-vault-test.id
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

resource "random_password" "license-server-rnd-pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "licenseserver-test" {
  name         = "licenseserver"
  value        = jsonencode({"username" : "lcserveruser","password" : "${random_password.license-server-rnd-pass.result}"})
  key_vault_id = azurerm_key_vault.simphera-key-vault-test.id
}

resource "random_password" "postgresql-rnd-pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "postgresqlCredentials-test" {
  name         = "postgresqlCredentials"
  value        = jsonencode({"postgresql_username" : "dbuser","postgresql_password" : "${random_password.postgresql-rnd-pass.result}"})
  key_vault_id = azurerm_key_vault.simphera-key-vault-test.id
}

resource "azurerm_private_endpoint" "keyvault-private-endpoint" {
  name                = "keyvault-private-endpoint"
  location            = var.location
  resource_group_name = local.keyvaultresourcenametest
  subnet_id           = azurerm_subnet.paas-services-subnet.id

  private_dns_zone_group {
    name                 = "keyvault-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault-privatelink-dns-zone.id]
  }

  private_service_connection {
    name                           = "simphera-keyvault"
    private_connection_resource_id = azurerm_key_vault.simphera-key-vault-test.id
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
