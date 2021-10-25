
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

output "minio_storage_username" {
  value = local.storageaccountname
}

output "minio_storage_password" {
  value     = azurerm_storage_account.minio_storage_account.primary_access_key
  sensitive = true
}