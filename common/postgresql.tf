resource "azurerm_resource_group" "postgres" {
  provider  = azurerm.cluster-provider-subscription
  name      = "${var.infrastructurename}-postgresql"
  location  = "${var.location}"
  tags      = var.tags
}

resource "azurerm_postgresql_server" "postgresql-server" {
  provider            = azurerm.cluster-provider-subscription
  name                = "${var.infrastructurename}-postgresql"
  location            = azurerm_resource_group.postgres.location
  resource_group_name = azurerm_resource_group.postgres.name

  administrator_login          = var.postgresqlAdminLogin
  administrator_login_password = var.postgresqlAdminPassword

  sku_name   = var.postgresqlSkuName
  version    = var.postgresqlVersion
  storage_mb = var.postgresqlStorage

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  auto_grow_enabled                = false

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = false

  tags = var.tags
}

resource "azurerm_private_endpoint" "postgresql-endpoint" {
  provider               = azurerm.cluster-provider-subscription
  name                   = "postgresql-endpoint"
  location               = azurerm_postgresql_server.postgresql-server.location
  resource_group_name    = azurerm_postgresql_server.postgresql-server.resource_group_name
  subnet_id              = azurerm_subnet.paas-services-subnet.id
  
  private_dns_zone_group {
    name = "postgresql-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.postgresql-privatelink-dns-zone.id]
  } 

  private_service_connection {
    name                           = "simphera-postgresql"
    private_connection_resource_id = azurerm_postgresql_server.postgresql-server.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  tags = var.tags
}

resource "azurerm_postgresql_database" "grafana" {
  provider              = azurerm.cluster-provider-subscription
  name                  = "grafana"
  resource_group_name   = azurerm_postgresql_server.postgresql-server.resource_group_name
  server_name           = azurerm_postgresql_server.postgresql-server.name
  charset               = "UTF8"
  collation             = "English_United States.1252"
}
