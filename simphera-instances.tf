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

  name                        = each.value.name
  minioAccountReplicationType = each.value.minioAccountReplicationType
  postgresqlAdminLogin        = each.value.postgresqlAdminLogin
  postgresqlAdminPassword     = each.value.postgresqlAdminPassword
  postgresqlVersion           = each.value.postgresqlVersion
  postgresqlSkuName           = each.value.postgresqlSkuName
  postgresqlStorage           = each.value.postgresqlStorage
}