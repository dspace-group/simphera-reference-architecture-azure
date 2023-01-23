

data "azurerm_key_vault_secret" "license_server_secret" {
  count        = var.licenseServer ? 1 : 0
  name         = "licenseserver"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault" "keyvault" {
  name                = var.keyVault
  resource_group_name = var.keyVaultResourceGroup
}
