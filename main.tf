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
  environment    = var.environment
}

provider "azurerm" {
  alias           = "cluster-provider-subscription"
  subscription_id = local.subscriptionId
  environment     = local.environment
  features {}
}

# The following block is needed to get around the following error:
# Error: Invalid required_providers object
provider "azurerm" {
  features {}
}