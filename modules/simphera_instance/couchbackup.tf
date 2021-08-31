resource "azurerm_resource_group" "couchbackup"{
  name      = "${var.name}-couchbackup"
  location  = "${var.location}"
  tags      = var.tags
}

resource "random_uuid" "couchbackup-acl" {
}

resource "azurerm_storage_account" "couchbackup_storage_account" {
  name                     = join("", [substr(replace(var.name, "-", ""), 0, 13), "couchbackup"])
  resource_group_name      = azurerm_resource_group.couchbackup.name
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Cool"
}

resource "azurerm_storage_share" "couchbackup-share" {
  name                 = "couchbackup-share"
  storage_account_name = azurerm_storage_account.couchbackup_storage_account.name
  quota                = 50

  acl {
    id = random_uuid.couchbackup-acl.id

    access_policy {
      permissions = "rwdl"

    }
  }
}