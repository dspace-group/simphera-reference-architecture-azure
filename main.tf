terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
    random = {
      version = "3.5.1"
    }
    local = {
      version = "2.4.0"
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

  location                                 = var.location
  infrastructurename                       = var.infrastructurename
  tags                                     = var.tags
  linuxNodeSize                            = var.linuxNodeSize
  linuxNodeDiskSize                        = var.linuxNodeDiskSize
  linuxNodeCountMin                        = var.linuxNodeCountMin
  linuxNodeCountMax                        = var.linuxNodeCountMax
  linuxExecutionNodeSize                   = var.linuxExecutionNodeSize
  linuxExecutionNodeDiskSize               = var.linuxExecutionNodeDiskSize
  linuxExecutionNodeCountMin               = var.linuxExecutionNodeCountMin
  linuxExecutionNodeCountMax               = var.linuxExecutionNodeCountMax
  linuxExecutionNodeDeallocate             = var.linuxExecutionNodeDeallocate
  gpuNodePool                              = var.gpuNodePool
  gpuNodeCountMin                          = var.gpuNodeCountMin
  gpuNodeCountMax                          = var.gpuNodeCountMax
  gpuNodeSize                              = var.gpuNodeSize
  gpuNodeDiskSize                          = var.gpuNodeDiskSize
  gpuNodeDeallocate                        = var.gpuNodeDeallocate
  ssh_public_key_path                      = var.ssh_public_key_path
  licenseServer                            = var.licenseServer
  licenseServerIaaSAntimalware             = var.licenseServerIaaSAntimalware
  licenseServerMicrosoftMonitoringAgent    = var.licenseServerMicrosoftMonitoringAgent
  licenseServerMicrosoftGuestConfiguration = var.licenseServerMicrosoftGuestConfiguration
  logAnalyticsWorkspaceName                = var.logAnalyticsWorkspaceName
  logAnalyticsWorkspaceResourceGroupName   = var.logAnalyticsWorkspaceResourceGroupName
  kubernetesVersion                        = var.kubernetesVersion
  kubernetesTier                           = var.kubernetesTier
  keyVaultPurgeProtection                  = var.keyVaultPurgeProtection
  keyVaultAuthorizedIpRanges               = var.keyVaultAuthorizedIpRanges
  simpheraInstances                        = var.simpheraInstances
  apiServerAuthorizedIpRanges              = var.apiServerAuthorizedIpRanges
  automaticChannelUpgrade                  = var.automaticChannelUpgrade
  nodeOsChannelUpgrade                     = var.nodeOsChannelUpgrade
}
