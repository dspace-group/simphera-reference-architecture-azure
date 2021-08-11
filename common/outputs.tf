


output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}
