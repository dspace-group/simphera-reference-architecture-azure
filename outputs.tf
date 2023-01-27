

output "kube_config" {
  value     = module.simphera-base.kube_config
  sensitive = true
}

output "postgresql_server_hostnames" {
  value = module.simphera-base.postgresql_server_hostnames
}

output "postgresql_server_usernames" {
  value     = module.simphera-base.postgresql_server_usernames
  sensitive = true
}

output "secretnames" {
  value = module.simphera-base.secretnames
}

output "minio_storage_usernames" {
  value = module.simphera-base.minio_storage_usernames
}
