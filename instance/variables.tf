variable subscriptionId {
  type        = string
  description = "The ID of the Azure subscription to be used."
}

variable location {
  type        = string
  description = "The Azure location to be used."
}

variable infrastructurename {
  type        = string
  description = "The name of the infrastructure. e.g. simphera-infra"
}

variable instancename {
  type        = string
  description = "The name of the cluster. e.g. production"
}

variable tags {
  type        = map
  description = "The tags to be added to all resources."
  default     = {}
}

variable "minioAccountReplicationType" {
    type        = string
    description = "The type of replication for the storage account. Can be LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS."
    default     = "ZRS"
}

variable postgresqlAdminLogin {
  type        = string
  description = "Login name of the account for the PostgreSQL Server"
  sensitive = true
}

variable postgresqlAdminPassword {
  type        = string
  description = "Password of the account for the PostgreSQL Server"
  sensitive   = true
}

variable postgresqlVersion {
  type        = string
  description = "PostgreSQL Server version to deploy"
  default     = "11"
}

variable postgresqlSkuName {
  type        = string
  description = "PostgreSQL SKU Name"
  default     = "GP_Gen5_2"
}

variable postgresqlStorage {
  type        = number
  description = "PostgreSQL Storage in MB, must be divisble by 1024"
  default     = 640000
}