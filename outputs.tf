

output "kube_config" {
  value     = module.simphera-common.kube_config
  sensitive = true
}

output "postgresql_server_hostnames" {
  value = module.simphera-common.postgresql_server_hostnames
}

output "postgresql_server_usernames" {
  value     = module.simphera-common.postgresql_server_usernames
  sensitive = true
}

output "secretnames" {
  value = module.simphera-common.secretnames
}

output "minio_storage_usernames" {
  value = module.simphera-common.minio_storage_usernames
}
