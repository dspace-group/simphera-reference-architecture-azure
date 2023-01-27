terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.27.0"
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

module "simphera-base" {
  source = "./modules/simphera_base"

  location                                 = var.location
  infrastructurename                       = var.infrastructurename
  tags                                     = var.tags
  linuxNodeSize                            = var.linuxNodeSize
  linuxNodeCountMin                        = var.linuxNodeCountMin
  linuxNodeCountMax                        = var.linuxNodeCountMax
  linuxExecutionNodeSize                   = var.linuxExecutionNodeSize
  linuxExecutionNodeCountMin               = var.linuxExecutionNodeCountMin
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
  keyVault                                 = var.keyVault
  keyVaultResourceGroup                    = var.keyVaultResourceGroup
  encryptionKeyUrl                         = var.encryptionKeyUrl
  simpheraInstances                        = var.simpheraInstances
  apiServerAuthorizedIpRanges              = var.apiServerAuthorizedIpRanges
}
