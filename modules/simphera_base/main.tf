terraform {
  required_version = ">= 1.0.0"

}

locals {
  log_analytics_enabled = var.logAnalyticsWorkspaceName != "" ? true : false
  license_server_secret = var.licenseServer ? jsondecode(data.azurerm_key_vault_secret.license_server_secret[0].value) : { username = "", password = "" }
}
