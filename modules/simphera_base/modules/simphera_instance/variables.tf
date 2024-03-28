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

variable "postgresqlSubnetId" {
  type        = string
  description = "The id of the subnet PostgreSQL"
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
  default     = "GP_Standard_D2ds_v4"
}

variable "postgresqlKeycloakDbEnable" {
  type        = bool
  description = "A switch to enable/disable creation of Keycloak DB in PostgreSQL server"
  default     = true
}

variable "postgresqlStorage" {
  type        = number
  description = "PostgreSQL Storage in MB, must be divisble by 1024"
  default     = 5120
}

variable "postgresqlGeoBackup" {
  type        = bool
  description = "Enable geo-redundant backups for the PostgreSQL Flexible Server"
  default     = false
}

variable "keyVaultId" {
  type        = string
  description = "Id of the KeyVault"
}

variable "backupRetention" {
  type        = number
  description = "Restore retention in days."
  default     = 7
}
