resource "azurerm_resource_group" "postgres" {
  name     = "${var.name}-postgresql"
  location = var.location
  tags     = var.tags
}

locals {
  servername = "${var.name}-postgresql"
  login      = var.postgresqlAdminLogin
  password   = var.postgresqlAdminPassword
  fulllogin  = "${var.postgresqlAdminLogin}@${local.servername}"
}

resource "azurerm_postgresql_server" "postgresql-server" {
  name                = local.servername
  location            = azurerm_resource_group.postgres.location
  resource_group_name = azurerm_resource_group.postgres.name

  administrator_login          = local.login
  administrator_login_password = local.password

  sku_name   = var.postgresqlSkuName
  version    = var.postgresqlVersion
  storage_mb = var.postgresqlStorage

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled = false
  ssl_enforcement_enabled       = false

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

output "postgresql_server_hostname" {
  value     = azurerm_postgresql_server.postgresql-server.fqdn
  sensitive = false
}

output "postgresql_server_username" {
  value     = local.fulllogin
  sensitive = false
}

output "postgresql_server_password" {
  value     = var.postgresqlAdminPassword
  sensitive = true
}

resource "azurerm_private_endpoint" "postgresql-endpoint" {
  name                = "postgresql-endpoint"
  location            = azurerm_postgresql_server.postgresql-server.location
  resource_group_name = azurerm_postgresql_server.postgresql-server.resource_group_name
  subnet_id           = var.paasServicesSubnetId

  private_dns_zone_group {
    name                 = "postgresql-zone-group"
    private_dns_zone_ids = [var.postgresqlPrivatelinkDnsZoneId]
  }

  private_service_connection {
    name                           = "simphera-postgresql"
    private_connection_resource_id = azurerm_postgresql_server.postgresql-server.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_postgresql_database" "keycloak" {
  name                = "keycloak"
  resource_group_name = azurerm_postgresql_server.postgresql-server.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "simphera" {
  name                = "simphera"
  resource_group_name = azurerm_postgresql_server.postgresql-server.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
