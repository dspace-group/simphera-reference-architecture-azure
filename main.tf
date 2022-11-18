terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.27.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscriptionId
  environment     = var.environment
  features {}
}

locals {
  log_analytics_enabled = var.logAnalyticsWorkspaceName != "" ? true : false
  license_server_secret = jsondecode(data.azurerm_key_vault_secret.license_server_secret.value)

}
