variable "subscriptionId" {
  type        = string
  description = "The ID of the Azure subscription to be used."
}

variable "environment" {
  type        = string
  default     = "public"
  description = "The Azure environment to be used."
}

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

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public SSH key to be used for the kubernetes nodes."
  default     = "shared-ssh-key/ssh.pub"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the private SSH key to be used for the kubernetes nodes."
  default     = "shared-ssh-key/ssh"
}

variable "licenseServer" {
  type        = bool
  description = "Specifies whether a VM for the dSPACE Installation Manager will be deployed."
  default     = false
}

variable "licenseServerAdminLogin" {
  type        = string
  description = "Login name of the local user of the license server"
  sensitive   = true
}

variable "licenseServerAdminPassword" {
  type        = string
  description = "Password of the local user of the license server"
  sensitive   = true
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
  default     = "1.23.12"
}

variable "simpheraInstances" {
  type = map(object({
    name                        = string
    minioAccountReplicationType = string
    postgresqlAdminLogin        = string
    postgresqlAdminPassword     = string
    postgresqlVersion           = string
    postgresqlSkuName           = string
    postgresqlStorage           = number
  }))

  description = "A list containing the individual SIMPHERA instances, such as 'staging' and 'production'."
  default     = {}
}

variable "allowedContainerImagesRegex" {
  type        = string
  description = "The RegEx rule used to match allowed container image field in a Kubernetes cluster. For example, to allow any Azure Container Registry image by matching partial path: ^[^\\/]+\\.azurecr\\.io\\/.+$ and for multiple registries: ^([^\\/]+\\.azurecr\\.io|registry\\.io)\\/.+$"
  default     = "^(docker.io/groundnuty/k8s-wait-for|quay.io/oauth2-proxy/oauth2-proxy|docker.io/jboss/keycloak|docker.io/busybox|docker.io/eclipse-mosquitto|docker.io/bitnami/pgbouncer|registry.dspace.cloud/dspace/simphera/.*)(:.*)?$"
}
