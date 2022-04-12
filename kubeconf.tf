resource "local_file" "kubeconfig" {
  content              = local.log_analytics_enabled ? azurerm_kubernetes_cluster.aks_with_logs[0].kube_config_raw : azurerm_kubernetes_cluster.aks[0].kube_config_raw
  filename             = "./${var.infrastructurename}.kubeconfig"
  file_permission      = "0600"
  directory_permission = "0755"
}