resource "local_file" "kubeconfig" {
  content              = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename             = "./${var.infrastructurename}.kubeconfig"
  file_permission      = "0600"
  directory_permission = "0755"
}