resource "azurerm_resource_group" "postgres" {
  name     = "${var.name}-postgresql"
  location = var.location
  tags     = var.tags
}

locals {
  servername = "${var.name}-postgresql"
  username      = local.secrets["postgresql_username"]
  fulllogin  = "${local.username}@${local.servername}"
  basic_tier = split("_", var.postgresqlSkuName)[0] == "B"
  gp_tier    = split("_", var.postgresqlSkuName)[0] == "GP"
  secrets    = jsondecode(data.azurerm_key_vault_secret.secrets.value)
}

resource "azurerm_postgresql_server" "postgresql-server" {
  name                = local.servername
  location            = azurerm_resource_group.postgres.location
  resource_group_name = azurerm_resource_group.postgres.name

  administrator_login          = local.secrets["postgresql_username"]
  administrator_login_password = local.secrets["postgresql_password"]

  sku_name   = var.postgresqlSkuName
  version    = var.postgresqlVersion
  storage_mb = var.postgresqlStorage

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled    = local.basic_tier ? true : false
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"


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
  sensitive = true
}

resource "azurerm_private_endpoint" "postgresql-endpoint" {
  count               = local.gp_tier ? 1 : 0
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

resource "azurerm_postgresql_firewall_rule" "postgresql-firewall" {
  count               = local.basic_tier ? 1 : 0
  name                = "aks_cluster"
  resource_group_name = azurerm_resource_group.postgres.name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  start_ip_address    = var.aksIpAddress
  end_ip_address      = var.aksIpAddress
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
