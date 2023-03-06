terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.27.0"
    }
    random = {
      version = "3.4.3"
    }
    local = {
      version = "2.2.3"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscriptionId
  environment     = var.environment
  features {}
}


module "simphera_base" {
  source = "./modules/simphera_base"

  infrastructurename                       = var.infrastructurename
  tags                                     = var.tags
  linuxNodeSize                            = var.linuxNodeSize
  linuxNodeCountMin                        = var.linuxNodeCountMin
  linuxExecutionNodeSize                   = var.linuxExecutionNodeSize
  linuxExecutionNodeCountMax               = var.linuxExecutionNodeCountMax
  linuxExecutionNodeDeallocate             = var.linuxExecutionNodeDeallocate
  gpuNodePool                              = var.gpuNodePool
  gpuNodeCountMin                          = var.gpuNodeCountMin
  gpuNodeCountMax                          = var.gpuNodeCountMax
  gpuNodeSize                              = var.gpuNodeSize
  gpuNodeDeallocate                        = var.gpuNodeDeallocate
  ssh_public_key_path                      = var.ssh_public_key_path
  licenseServer                            = var.licenseServer
  licenseServerIaaSAntimalware             = var.licenseServerIaaSAntimalware
  licenseServerMicrosoftMonitoringAgent    = var.licenseServerMicrosoftMonitoringAgent
  licenseServerMicrosoftGuestConfiguration = var.licenseServerMicrosoftGuestConfiguration
  logAnalyticsWorkspaceName                = var.logAnalyticsWorkspaceName
  logAnalyticsWorkspaceResourceGroupName   = var.logAnalyticsWorkspaceResourceGroupName
  kubernetesVersion                        = var.kubernetesVersion
  keyVaultAuthorizedIpRanges               = var.keyVaultAuthorizedIpRanges
  simpheraInstances                        = var.simpheraInstances
  apiServerAuthorizedIpRanges              = var.apiServerAuthorizedIpRanges

}
