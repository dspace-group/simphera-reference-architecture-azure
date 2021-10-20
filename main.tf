terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.58.0"
     }
  }
}

provider "azurerm" {
  subscription_id = var.subscriptionId
  environment = var.environment
  features {}
}
