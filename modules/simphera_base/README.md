<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_simphera_instance"></a> [simphera\_instance](#module\_simphera\_instance) | ./modules/simphera_instance | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.bastion-host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_key_vault.simphera-key-vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.azure-disk-encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.license-server-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.execution-nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.gpu-execution-nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_network_interface.license-server-nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.ni-license-server-sga](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.license-server-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_dns_zone.keyvault-privatelink-dns-zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.minio-privatelink-dns-zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.postgresql-privatelink-dns-zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.keyvault-privatelink-network-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.minio-privatelink-network-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.postgresql-privatelink-network-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.keyvault-private-endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.bastion-pubip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.license-server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.bastion-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.default-node-pool-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.execution-nodes-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.gpu-nodes-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.license-server-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.paas-services-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.azureDiskEncryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.gc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.iaaSAntimalware](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.microsoftMonitoringAgent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.simphera-vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.license-server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_password.license-server-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.log-analytics-workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_public_ip.aks_outgoing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apiServerAuthorizedIpRanges"></a> [apiServerAuthorizedIpRanges](#input\_apiServerAuthorizedIpRanges) | List of authorized IP address ranges that are granted access to the Kubernetes API server, e.g. ["198.51.100.0/24"] | `set(string)` | `null` | no |
| <a name="input_gpuNodeCountMax"></a> [gpuNodeCountMax](#input\_gpuNodeCountMax) | The maximum number of nodes for gpu job execution | `number` | `12` | no |
| <a name="input_gpuNodeCountMin"></a> [gpuNodeCountMin](#input\_gpuNodeCountMin) | The minimum number of nodes for gpu job execution | `number` | `0` | no |
| <a name="input_gpuNodeDeallocate"></a> [gpuNodeDeallocate](#input\_gpuNodeDeallocate) | Configures whether the nodes for the gpu job execution are 'Deallocated (Stopped)' by the cluster auto scaler or 'Deleted'. | `bool` | `true` | no |
| <a name="input_gpuNodePool"></a> [gpuNodePool](#input\_gpuNodePool) | Specifies whether an additional node pool for gpu job execution is added to the kubernetes cluster | `bool` | `false` | no |
| <a name="input_gpuNodeSize"></a> [gpuNodeSize](#input\_gpuNodeSize) | The machine size of the nodes for the gpu job execution | `string` | `"Standard_NC16as_T4_v3"` | no |
| <a name="input_infrastructurename"></a> [infrastructurename](#input\_infrastructurename) | The name of the infrastructure. e.g. simphera-infra | `string` | n/a | yes |
| <a name="input_keyVaultAuthorizedIpRanges"></a> [keyVaultAuthorizedIpRanges](#input\_keyVaultAuthorizedIpRanges) | List of authorized IP address ranges that are granted access to the Key Vault, e.g. ["198.51.100.0/24"] | `set(string)` | `[]` | no |
| <a name="input_keyVaultPurgeProtection"></a> [keyVaultPurgeProtection](#input\_keyVaultPurgeProtection) | Specifies whether the Key vault purge protection is enabled. | `bool` | `true` | no |
| <a name="input_kubernetesVersion"></a> [kubernetesVersion](#input\_kubernetesVersion) | The version of the AKS cluster. | `string` | `"1.23.12"` | no |
| <a name="input_licenseServer"></a> [licenseServer](#input\_licenseServer) | Specifies whether a VM for the dSPACE Installation Manager will be deployed. | `bool` | `false` | no |
| <a name="input_licenseServerIaaSAntimalware"></a> [licenseServerIaaSAntimalware](#input\_licenseServerIaaSAntimalware) | Specifies whether a IaaSAntimalware extension will be installed on license server VM. Depends on licenseServer variable. | `bool` | `true` | no |
| <a name="input_licenseServerMicrosoftGuestConfiguration"></a> [licenseServerMicrosoftGuestConfiguration](#input\_licenseServerMicrosoftGuestConfiguration) | Specifies whether a Microsoft Guest configuration extension will be installed on license server VM. Depends on licenseServer variable. | `bool` | `true` | no |
| <a name="input_licenseServerMicrosoftMonitoringAgent"></a> [licenseServerMicrosoftMonitoringAgent](#input\_licenseServerMicrosoftMonitoringAgent) | Specifies whether a MicrosoftMonitoringAgent extension will be installed on license server VM. Depends on licenseServer, logAnalyticsWorkspaceName and logAnalyticsWorkspaceResourceGroupName variables. | `bool` | `true` | no |
| <a name="input_linuxExecutionNodeCountMax"></a> [linuxExecutionNodeCountMax](#input\_linuxExecutionNodeCountMax) | The maximum number of Linux nodes for the job execution | `number` | `10` | no |
| <a name="input_linuxExecutionNodeCountMin"></a> [linuxExecutionNodeCountMin](#input\_linuxExecutionNodeCountMin) | The minimum number of Linux nodes for the job execution | `number` | `0` | no |
| <a name="input_linuxExecutionNodeDeallocate"></a> [linuxExecutionNodeDeallocate](#input\_linuxExecutionNodeDeallocate) | Configures whether the Linux nodes for the job execution are 'Deallocated (Stopped)' by the cluster auto scaler or 'Deleted'. | `bool` | `true` | no |
| <a name="input_linuxExecutionNodeSize"></a> [linuxExecutionNodeSize](#input\_linuxExecutionNodeSize) | The machine size of the Linux nodes for the job execution | `string` | `"Standard_D16s_v4"` | no |
| <a name="input_linuxNodeCountMax"></a> [linuxNodeCountMax](#input\_linuxNodeCountMax) | The maximum number of Linux nodes for the regular services | `number` | `12` | no |
| <a name="input_linuxNodeCountMin"></a> [linuxNodeCountMin](#input\_linuxNodeCountMin) | The minimum number of Linux nodes for the regular services | `number` | `1` | no |
| <a name="input_linuxNodeSize"></a> [linuxNodeSize](#input\_linuxNodeSize) | The machine size of the Linux nodes for the regular services | `string` | `"Standard_D4s_v4"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure location to be used. | `string` | n/a | yes |
| <a name="input_logAnalyticsWorkspaceName"></a> [logAnalyticsWorkspaceName](#input\_logAnalyticsWorkspaceName) | The name of the Log Analytics Workspace to be used. Use empty string to disable usage of Log Analytics. | `string` | `""` | no |
| <a name="input_logAnalyticsWorkspaceResourceGroupName"></a> [logAnalyticsWorkspaceResourceGroupName](#input\_logAnalyticsWorkspaceResourceGroupName) | The name of the resource group of the Log Analytics Workspace to be used. | `string` | `""` | no |
| <a name="input_simpheraInstances"></a> [simpheraInstances](#input\_simpheraInstances) | A list containing the individual SIMPHERA instances, such as 'staging' and 'production'. | <pre>map(object({<br>    name                        = string<br>    minioAccountReplicationType = string<br>    postgresqlVersion           = string<br>    postgresqlSkuName           = string<br>    postgresqlStorage           = number<br>  }))</pre> | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to the public SSH key to be used for the kubernetes nodes. | `string` | `"shared-ssh-key/ssh.pub"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be added to all resources. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_minio_storage_usernames"></a> [minio\_storage\_usernames](#output\_minio\_storage\_usernames) | n/a |
| <a name="output_postgresql_server_hostnames"></a> [postgresql\_server\_hostnames](#output\_postgresql\_server\_hostnames) | n/a |
| <a name="output_postgresql_server_usernames"></a> [postgresql\_server\_usernames](#output\_postgresql\_server\_usernames) | n/a |
| <a name="output_secretnames"></a> [secretnames](#output\_secretnames) | n/a |
<!-- END_TF_DOCS -->