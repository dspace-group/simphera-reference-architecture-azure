resource "azurerm_resource_group" "postgres" {
  name     = "${var.name}-postgresql"
  location = var.location
  tags     = var.tags
}

resource "random_password" "postgresql-password" {
  length           = 16
  special          = true
  override_special = "!#%&*-_+?"
  min_lower        = 2
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
}

resource "azurerm_key_vault_secret" "postgresql-credentials" {
  name         = "${var.name}-postgresqlcredentials"
  value        = jsonencode({ "postgresql_username" : "dbuser", "postgresql_password" : random_password.postgresql-password.result })
  key_vault_id = var.keyVaultId
}

locals {
  servername          = "${var.name}-postgresql"
  postgresql_username = jsondecode(azurerm_key_vault_secret.postgresql-credentials.value)["postgresql_username"]
  postgresql_password = jsondecode(azurerm_key_vault_secret.postgresql-credentials.value)["postgresql_password"]
  fulllogin           = "${local.postgresql_username}@${local.servername}"
}

resource "azurerm_postgresql_flexible_server" "postgresql-flexible" {
  name                = local.servername
  location            = azurerm_resource_group.postgres.location
  resource_group_name = azurerm_resource_group.postgres.name

  administrator_login    = local.postgresql_username
  administrator_password = local.postgresql_password
  delegated_subnet_id    = var.postgresqlSubnetId
  private_dns_zone_id    = var.postgresqlPrivatelinkDnsZoneId

  sku_name   = var.postgresqlSkuName
  version    = var.postgresqlVersion
  storage_mb = var.postgresqlStorage

  backup_retention_days        = var.backupRetention
  geo_redundant_backup_enabled = var.postgresqlGeoBackup

  authentication {
    active_directory_auth_enabled = true
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      zone # Azure will automatically assign an Availability Zone
    ]
  }

}


output "postgresql_server_hostname" {
  value     = azurerm_postgresql_flexible_server.postgresql-flexible.fqdn
  sensitive = false
}

output "postgresql_server_username" {
  value     = local.fulllogin
  sensitive = true
}

resource "azurerm_postgresql_flexible_server_database" "keycloak" {
  name      = "keycloak"
  server_id = azurerm_postgresql_flexible_server.postgresql-flexible.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_database" "simphera" {
  name      = "simphera"
  server_id = azurerm_postgresql_flexible_server.postgresql-flexible.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_configuration" "pgcrypto" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.postgresql-flexible.id
  value     = "PGCRYPTO"
}

output "secretname" {
  value = azurerm_key_vault_secret.postgresql-credentials.name
}
