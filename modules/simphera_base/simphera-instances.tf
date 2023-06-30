module "simphera_instance" {
  for_each = var.simpheraInstances

  source = "./modules/simphera_instance"

  location                       = var.location
  infrastructurename             = var.infrastructurename
  tags                           = var.tags
  paasServicesSubnetId           = azurerm_subnet.paas-services-subnet.id
  postgresqlSubnetId             = azurerm_subnet.postgresql-server-subnet.id
  postgresqlPrivatelinkDnsZoneId = azurerm_private_dns_zone.postgresql-privatelink-dns-zone.id
  minioPrivatelinkDnsZoneId      = azurerm_private_dns_zone.minio-privatelink-dns-zone.id
  aksIpAddress                   = data.azurerm_public_ip.aks_outgoing.ip_address
  keyVaultId                     = azurerm_key_vault.simphera-key-vault.id
  name                           = each.value.name
  minioAccountReplicationType    = each.value.minioAccountReplicationType
  postgresqlVersion              = each.value.postgresqlVersion
  postgresqlSkuName              = each.value.postgresqlSkuName
  postgresqlStorage              = each.value.postgresqlStorage
  postgresqlGeoBackup            = each.value.postgresqlGeoBackup
  backupRetention                = each.value.backupRetention
}

output "postgresql_server_hostnames" {
  value = {
    for name, instance in module.simphera_instance : name => instance.postgresql_server_hostname
  }
}

output "postgresql_server_usernames" {
  value = {
    for name, instance in module.simphera_instance : name => instance.postgresql_server_username
  }
  sensitive = true
}

output "secretnames" {
  value = {
    for name, instance in module.simphera_instance : name => instance.secretname
  }
}

output "minio_storage_usernames" {
  value = {
    for name, instance in module.simphera_instance : name => instance.minio_storage_username
  }
}
