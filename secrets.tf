

data "azurerm_key_vault_secret" "license_server_secret" {
  name         = "licenseserver"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}