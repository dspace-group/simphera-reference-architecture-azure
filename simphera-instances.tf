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

  name                        = each.value.name
  minioAccountReplicationType = each.value.minioAccountReplicationType
  postgresqlAdminLogin        = each.value.postgresqlAdminLogin
  postgresqlAdminPassword     = each.value.postgresqlAdminPassword
  postgresqlVersion           = each.value.postgresqlVersion
  postgresqlSkuName           = each.value.postgresqlSkuName
  postgresqlStorage           = each.value.postgresqlStorage
}

output "postgresql_server_hostnames" {
  value = tomap({
    for name, instance in module.simphera_instance : name => instance.postgresql_server_hostname
  })
}

output "postgresql_server_usernames" {
  value = tomap({
    for name, instance in module.simphera_instance : name => instance.postgresql_server_username
  })
  sensitive = true
}

output "postgresql_server_passwords" {
  value = tomap({
    for name, instance in module.simphera_instance : name => instance.postgresql_server_password
  })
  sensitive = true
}

output "minio_storage_usernames" {
  value = tomap({
    for name, instance in module.simphera_instance : name => instance.minio_storage_username
  })
}

output "minio_storage_passwords" {
  value = tomap({
    for name, instance in module.simphera_instance : name => instance.minio_storage_password
  })
  sensitive = true
}
