module "simphera_instance" {
  for_each = var.simpheraInstances

  source = "./modules/simphera_instance"

  subscriptionId                 = var.subscriptionId
  environment                    = var.environment
  location                       = var.location
  infrastructurename             = var.infrastructurename
  tags                           = var.tags
  paasServicesSubnetId           = azurerm_subnet.paas-services-subnet.id
  postgresqlPrivatelinkDnsZoneId = azurerm_private_dns_zone.postgresql-privatelink-dns-zone.id
  aksIpAddress                   = data.azurerm_public_ip.aks_outgoing.ip_address
  keyVault                       = data.azurerm_key_vault.keyvault.id
  name                           = each.value.name
  minioAccountReplicationType    = each.value.minioAccountReplicationType
  secretname                     = each.value.secretname
  postgresqlVersion              = each.value.postgresqlVersion
  postgresqlSkuName              = each.value.postgresqlSkuName
  postgresqlStorage              = each.value.postgresqlStorage
}

output "postgresql_server_hostnames" {
  description = "Map whose keys are SIMPHERA instance names and values are PostgreSQL hostnames."
  value = {
    for name, instance in module.simphera_instance : name => instance.postgresql_server_hostname
  }
}

output "postgresql_server_usernames" {
  description = "Map whose keys are SIMPHERA instance names and values are PostgreSQL usernames."
  value = {
    for name, instance in module.simphera_instance : name => instance.postgresql_server_username
  }
  sensitive = true
}

output "secretnames" {
  description = "Map whose keys are SIMPHERA instance names and values are names of the KeyVault secrets."
  value = {
    for name, instance in module.simphera_instance : name => instance.secretname
  }
}

output "minio_storage_usernames" {
  description = "Map whose keys are SIMPHERA instance names and values are MinIO usernames."
  value = {
    for name, instance in module.simphera_instance : name => instance.minio_storage_username
  }
}

