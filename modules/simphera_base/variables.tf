variable "location" {
  type        = string
  description = "The Azure location to be used."
}

variable "infrastructurename" {
  type        = string
  description = "The name of the infrastructure. e.g. simphera-infra"
}

variable "tags" {
  type        = map(any)
  description = "The tags to be added to all resources."
  default     = {}
}

variable "linuxNodeSize" {
  type        = string
  description = "The machine size of the Linux nodes for the regular services"
  default     = "Standard_D4s_v4"
}

variable "linuxNodeCountMin" {
  type        = number
  description = "The minimum number of Linux nodes for the regular services"
  default     = 1
}

variable "linuxNodeCountMax" {
  type        = number
  description = "The maximum number of Linux nodes for the regular services"
  default     = 12
}

variable "linuxExecutionNodeSize" {
  type        = string
  description = "The machine size of the Linux nodes for the job execution"
  default     = "Standard_D16s_v4"
}

variable "linuxExecutionNodeCountMin" {
  type        = number
  description = "The minimum number of Linux nodes for the job execution"
  default     = 0
}

variable "linuxExecutionNodeCountMax" {
  type        = number
  description = "The maximum number of Linux nodes for the job execution"
  default     = 10
}

variable "linuxExecutionNodeDeallocate" {
  type        = bool
  description = "Configures whether the Linux nodes for the job execution are 'Deallocated (Stopped)' by the cluster auto scaler or 'Deleted'."
  default     = true
}

variable "gpuNodePool" {
  type        = bool
  description = "Specifies whether an additional node pool for gpu job execution is added to the kubernetes cluster"
  default     = false
}

variable "gpuNodeCountMin" {
  type        = number
  description = "The minimum number of nodes for gpu job execution"
  default     = 0
}

variable "gpuNodeCountMax" {
  type        = number
  description = "The maximum number of nodes for gpu job execution"
  default     = 12
}

variable "gpuNodeSize" {
  type        = string
  description = "The machine size of the nodes for the gpu job execution"
  default     = "Standard_NC16as_T4_v3"
}

variable "gpuNodeDeallocate" {
  type        = bool
  description = "Configures whether the nodes for the gpu job execution are 'Deallocated (Stopped)' by the cluster auto scaler or 'Deleted'."
  default     = true
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public SSH key to be used for the kubernetes nodes."
  default     = "shared-ssh-key/ssh.pub"
}

variable "licenseServer" {
  type        = bool
  description = "Specifies whether a VM for the dSPACE Installation Manager will be deployed."
  default     = false
}

variable "licenseServerIaaSAntimalware" {
  type        = bool
  description = "Specifies whether a IaaSAntimalware extension will be installed on license server VM. Depends on licenseServer variable."
  default     = true
}

variable "licenseServerMicrosoftMonitoringAgent" {
  type        = bool
  description = "Specifies whether a MicrosoftMonitoringAgent extension will be installed on license server VM. Depends on licenseServer, logAnalyticsWorkspaceName and logAnalyticsWorkspaceResourceGroupName variables."
  default     = true
}

variable "licenseServerMicrosoftGuestConfiguration" {
  type        = bool
  description = "Specifies whether a Microsoft Guest configuration extension will be installed on license server VM. Depends on licenseServer variable."
  default     = true
}

variable "logAnalyticsWorkspaceName" {
  type        = string
  description = "The name of the Log Analytics Workspace to be used. Use empty string to disable usage of Log Analytics."
  default     = ""
}

variable "logAnalyticsWorkspaceResourceGroupName" {
  type        = string
  description = "The name of the resource group of the Log Analytics Workspace to be used."
  default     = ""
}

variable "kubernetesVersion" {
  type        = string
  description = "The version of the AKS cluster."
  default     = "1.28.3"
}

variable "kubernetesTier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster."
  default     = "Free"
}

variable "keyVaultPurgeProtection" {
  type        = bool
  description = "Specifies whether the Key vault purge protection is enabled."
  default     = true
}

variable "keyVaultAuthorizedIpRanges" {
  type        = set(string)
  description = "List of authorized IP address ranges that are granted access to the Key Vault, e.g. [\"198.51.100.0/24\"]"
  default     = []
}

variable "simpheraInstances" {
  type = map(object({
    name                        = string
    minioAccountReplicationType = string
    postgresqlVersion           = string
    postgresqlSkuName           = string
    postgresqlStorage           = number
    postgresqlGeoBackup         = bool
    backupRetention             = number
  }))

  description = "A list containing the individual SIMPHERA instances, such as 'staging' and 'production'."
}

variable "apiServerAuthorizedIpRanges" {
  type        = set(string)
  description = "List of authorized IP address ranges that are granted access to the Kubernetes API server, e.g. [\"198.51.100.0/24\"]"
  default     = null
}

variable "automaticChannelUpgrade" {
  type        = string
  description = "The upgrade channel for the k8s cluster. POssible values are patch, rapid, node-image and stable"
  default     = null
}

variable "nodeOsChannelUpgrade" {
  type        = string
  description = "The upgrade channel for the k8s cluster's nodes os images."
  default     = "None"

  validation {
    condition     = contains(["Unmanaged", "SecurityPatch", "NodeImage", "None"], var.nodeOsChannelUpgrade)
    error_message = "Valid values for var: automaticChannelUpgrade are (Unmanaged, SecurityPatch, NodeImage,None)."
  }
}
