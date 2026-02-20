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

output "storage_account_names" {
  value = module.simphera_base.storage_account_names
}

output "container_blob_endpoint" {
  value = module.simphera_base.container_blob_endpoint
}

output "key_vault_uri" {
  value = module.simphera_base.key_vault_uri
}

output "key_vault_id" {
  value = module.simphera_base.key_vault_id
}

output "key_vault_name" {
  value = module.simphera_base.key_vault_name
}
