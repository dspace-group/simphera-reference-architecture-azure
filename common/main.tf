terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.58.0"
     }
  }
}

locals {
  subscriptionId = var.subscriptionId
}  

provider "azurerm"{
  alias  = "cluster-provider-subscription"
  subscription_id = local.subscriptionId
  features {}
}

data "azurerm_client_config" "current" {
  provider  = azurerm.cluster-provider-subscription
}
