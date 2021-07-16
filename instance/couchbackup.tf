resource "azurerm_resource_group" "couchbackup"{
  provider  = azurerm.cluster-provider-subscription
  name      = "${var.instancename}-couchbackup"
  location  = "${var.location}"
  tags      = var.tags
}

resource "random_uuid" "couchbackup-acl" {
}

resource "azurerm_storage_account" "couchbackup_storage_account" {
  name                     = join("", [substr(replace(var.instancename, "-", ""), 0, 13), "couchbackup"])
  provider                 = azurerm.cluster-provider-subscription
  resource_group_name      = azurerm_resource_group.couchbackup.name
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Cool"
}

resource "azurerm_storage_share" "couchbackup-share" {
  name                 = "couchbackup-share"
  provider             = azurerm.cluster-provider-subscription
  storage_account_name = azurerm_storage_account.couchbackup_storage_account.name
  quota                = 50

  acl {
    id = random_uuid.couchbackup-acl.id

    access_policy {
      permissions = "rwdl"

    }
  }
}