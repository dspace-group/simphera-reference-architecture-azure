variable "location" {
  type        = string
  description = "The Azure location to be used."
}

variable "infrastructurename" {
  type        = string
  description = "The name of the infrastructure. e.g. simphera-infra"
}

variable "paasServicesSubnetId" {
  type        = string
  description = "The id of the PaaS subnet"
}

variable "postgresqlPrivatelinkDnsZoneId" {
  type        = string
  description = "The id of the private DNS zone for PostgreSQL"
}

variable "minioPrivatelinkDnsZoneId" {
  type        = string
  description = "The id of the private DNS zone for MinIO"
}

variable "name" {
  type        = string
  description = "The name of the SIMPHERA instance. e.g. production"
}

variable "tags" {
  type        = map(any)
  description = "The tags to be added to all resources."
  default     = {}
}

variable "minioAccountReplicationType" {
  type        = string
  description = "The type of replication for the storage account. Can be LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS."
  default     = "ZRS"
}
variable "postgresqlVersion" {
  type        = string
  description = "PostgreSQL Server version to deploy"
  default     = "11"
}

variable "postgresqlSkuName" {
  type        = string
  description = "PostgreSQL SKU Name"
  default     = "GP_Gen5_2"
}

variable "postgresqlStorage" {
  type        = number
  description = "PostgreSQL Storage in MB, must be divisble by 1024"
  default     = 5120
}

variable "aksIpAddress" {
  type        = string
  description = "IP Address of the AKS cluster"
}

variable "keyVault" {
  type        = string
  description = "Name of the KeyVault"
}

variable "secretname" {
  type        = string
  description = "Name of the secret that stores credentials."
}
