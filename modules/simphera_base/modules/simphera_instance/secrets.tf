# tflint-ignore: terraform_required_providers
data "azurerm_key_vault_secret" "secrets" {
  name         = var.secretname
  key_vault_id = var.keyVault
}

output "secretname" {
  value = var.secretname
}
