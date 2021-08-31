
resource "azurerm_resource_group" "minio-storage" {
  name      = "${var.name}-storage"
  location  = "${var.location}"
  
  tags = var.tags
}

resource "azurerm_storage_account" "minio_storage_account" {
  name                     = substr(replace(var.name, "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.minio-storage.name
  location                 = azurerm_resource_group.minio-storage.location
  account_tier             = "Standard"
  account_replication_type = var.minioAccountReplicationType
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  tags = var.tags
}