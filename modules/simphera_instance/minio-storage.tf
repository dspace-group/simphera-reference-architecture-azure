
resource "azurerm_resource_group" "minio-storage" {
  name     = "${var.name}-storage"
  location = var.location

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

locals {
  storageaccountname = substr(replace(join("", [var.name, var.infrastructurename]), "-", ""), 0, 24)
}

resource "azurerm_storage_account" "minio_storage_account" {
  name                     = local.storageaccountname
  resource_group_name      = azurerm_resource_group.minio-storage.name
  location                 = azurerm_resource_group.minio-storage.location
  account_tier             = "Standard"
  account_replication_type = var.minioAccountReplicationType
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "minio-endpoint" {
  name                = "minio-endpoint"
  location            = azurerm_resource_group.minio-storage.location
  resource_group_name = azurerm_resource_group.minio-storage.name
  subnet_id           = var.paasServicesSubnetId

  private_dns_zone_group {
    name                 = "minio-zone-group"
    private_dns_zone_ids = [var.minioPrivatelinkDnsZoneId]
  }

  private_service_connection {
    name                           = "simphera-minio"
    private_connection_resource_id = azurerm_storage_account.minio_storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_account_network_rules" "minio_storage_network_rule" {
  storage_account_id = azurerm_storage_account.minio_storage_account.id

  default_action             = "Deny"
  ip_rules                   = []
  virtual_network_subnet_ids = [var.paasServicesSubnetId]
  bypass                     = ["AzureServices", "Metrics"]
}

output "minio_storage_username" {
  value = local.storageaccountname
}
