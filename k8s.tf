resource "azurerm_resource_group" "aks" {
  name     = "${var.infrastructurename}-aks"
  location = var.location
  tags     = var.tags
}

resource "azurerm_subnet" "default-node-pool-subnet" {
  name                 = "default-node-pool-subnet"
  resource_group_name  = azurerm_virtual_network.simphera-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.0.0/19"]
}

resource "azurerm_subnet" "execution-nodes-subnet" {
  name                 = "execution-nodes-subnet"
  resource_group_name  = azurerm_virtual_network.simphera-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.32.0/20"]
}

resource "azurerm_subnet" "gpu-nodes-subnet" {
  count                = var.gpuNodePool ? 1 : 0
  name                 = "execution-nodes-subnet"
  resource_group_name  = azurerm_virtual_network.simphera-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.48.0/20"]
}

data "azurerm_public_ip" "aks_outgoing" {
  name                = join("", (regex("([^/]+)$", join("", azurerm_kubernetes_cluster.aks.network_profile[0].load_balancer_profile[0].effective_outbound_ips))))
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                 = "${var.infrastructurename}-aks"
  location             = azurerm_resource_group.aks.location
  resource_group_name  = azurerm_resource_group.aks.name
  node_resource_group  = "${var.infrastructurename}-aks-node-pools"
  dns_prefix           = "${var.infrastructurename}-aks"
  kubernetes_version   = var.kubernetesVersion
  azure_policy_enabled = true
  linux_profile {
    admin_username = "simphera"
    ssh_key {
      key_data = file(var.ssh_public_key_path)
    }
  }

  default_node_pool {
    name                = "default"
    node_count          = var.linuxNodeCountMin
    vm_size             = var.linuxNodeSize
    min_count           = var.linuxNodeCountMin
    max_count           = var.linuxNodeCountMax
    enable_auto_scaling = true
    os_disk_size_gb     = 128
    type                = "VirtualMachineScaleSets"
    max_pods            = 110
    vnet_subnet_id      = azurerm_subnet.default-node-pool-subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.0.64.0/19"  # MUST be smaller than /12
    dns_service_ip     = "10.0.64.10"    # MUST NOT be the first IP address in the address range
    docker_bridge_cidr = "172.17.0.1/16" # MUST NOT collide with the rest of the CIDRs including the cluster's service CIDR and pod CIDR. Default is 172.17.0.1/16
  }


  dynamic "oms_agent" {
    for_each = local.log_analytics_enabled ? [1] : []
    content {

      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log-analytics-workspace[0].id

    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      tags,
      api_server_authorized_ip_ranges
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "execution-nodes" {
  name                  = "execnodes"
  mode                  = "User"
  orchestrator_version  = var.kubernetesVersion
  os_disk_size_gb       = 128
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  min_count             = var.linuxExecutionNodeCountMin
  max_count             = var.linuxExecutionNodeCountMax
  node_count            = var.linuxExecutionNodeCountMin
  vm_size               = var.linuxExecutionNodeSize
  max_pods              = 50
  enable_auto_scaling   = true
  vnet_subnet_id        = azurerm_subnet.execution-nodes-subnet.id

  node_labels = {
    "purpose" = "execution"
  }

  node_taints = [
    "purpose=execution:NoSchedule"
  ]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      zones,
      enable_host_encryption,
      enable_node_public_ip,
      vnet_subnet_id,
      node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu-execution-nodes" {
  count                 = var.gpuNodePool ? 1 : 0
  name                  = "gpuexecnodes"
  mode                  = "User"
  orchestrator_version  = var.kubernetesVersion
  os_disk_size_gb       = 128
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  min_count             = var.gpuNodeCountMin
  max_count             = var.gpuNodeCountMax
  node_count            = var.gpuNodeCountMin
  vm_size               = var.gpuNodeSize
  max_pods              = 50
  enable_auto_scaling   = true
  vnet_subnet_id        = azurerm_subnet.gpu-nodes-subnet[0].id

  node_labels = {
    "purpose" = "gpu"
  }

  node_taints = [
    "purpose=gpu:NoSchedule"
  ]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      zones,
      enable_host_encryption,
      enable_node_public_ip,
      vnet_subnet_id,
      node_count
    ]
  }
}

resource "azurerm_resource_policy_assignment" "K8sAzureContainerAllowedImages" {
  name                 = "K8sAzureContainerAllowedImages@${azurerm_kubernetes_cluster.aks.name}"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"
  resource_id          = azurerm_kubernetes_cluster.aks.id
  description          = "Kubernetes cluster containers should only use allowed images"
  display_name         = "K8sAzureContainerAllowedImages@${azurerm_kubernetes_cluster.aks.name}"
  parameters           = <<PARAMETERS
  {
  "allowedContainerImagesRegex": {
    "value": "${var.allowedContainerImagesRegex}" 
  }
}
PARAMETERS
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}
