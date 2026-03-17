module "simphera_instance" {
  for_each = var.simpheraInstances

  source = "./modules/simphera_instance"

  location                       = var.location
  infrastructurename             = var.infrastructurename
  tags                           = var.tags
  paasServicesSubnetId           = azurerm_subnet.paas-services-subnet.id
  postgresqlSubnetId             = azurerm_subnet.postgresql-server-subnet.id
  postgresqlPrivatelinkDnsZoneId = azurerm_private_dns_zone.postgresql-privatelink-dns-zone.id
  storagePrivatelinkDnsZoneId    = azurerm_private_dns_zone.storage_privatelink_dns_zone.id
  keyVaultId                     = azurerm_key_vault.simphera-key-vault.id
  name                           = each.value.name
  containerName                  = var.containerName
  storageAccountReplicationType  = each.value.storageAccountReplicationType
  postgresqlVersion              = each.value.postgresqlVersion
  postgresqlSkuName              = each.value.postgresqlSkuName
  postgresqlKeycloakDbEnable     = each.value.postgresqlKeycloakDbEnable
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

output "storage_account_names" {
  value = {
    for name, instance in module.simphera_instance : name => instance.storage_account_name
  }
}

output "container_blob_endpoints" {
  value = {
    for name, instance in module.simphera_instance : name => instance.container_blob_endpoint
  }
}
