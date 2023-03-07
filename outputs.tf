output "kube_config" {
  value     = module.simphera_base.kube_config
  sensitive = true
}

output "postgresql_server_hostnames" {
  value = module.simphera_base.postgresql_server_hostnames
}

output "postgresql_server_usernames" {
  value     = module.simphera_base.postgresql_server_usernames
  sensitive = true
}

output "secretnames" {
  value = module.simphera_base.secretnames
}

output "minio_storage_usernames" {
  value = module.simphera_base.minio_storage_usernames
}

output "key_vault_uri" {
  value = module.simphera_base.key_vault_uri
}

output "key_vault_id" {
  value = module.simphera_base.key_vault_id
}

output "minio_key_vault_namestorage_usernames" {
  value = module.simphera_base.key_vault_name
}
