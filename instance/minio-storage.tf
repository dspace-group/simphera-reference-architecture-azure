
resource "azurerm_resource_group" "minio-storage" {
  provider  = azurerm.cluster-provider-subscription
  name      = "${var.instancename}-storage"
  location  = "${var.location}"
  
  tags = var.tags
}

resource "azurerm_storage_account" "minio_storage_account" {
  name                     = substr(replace(var.instancename, "-", ""), 0, 24)
  provider                 = azurerm.cluster-provider-subscription
  resource_group_name      = azurerm_resource_group.minio-storage.name
  location                 = azurerm_resource_group.minio-storage.location
  account_tier             = "Standard"
  account_replication_type = var.minioAccountReplicationType
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  tags = var.tags
}