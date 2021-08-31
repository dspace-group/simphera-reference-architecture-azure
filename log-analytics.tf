data "azurerm_log_analytics_workspace" "log-analytics-workspace" {
  count               = "${var.logAnalyticsWorkspaceName != "" ? 1 : 0}"
  provider            = azurerm.cluster-provider-subscription
  name                = var.logAnalyticsWorkspaceName
  resource_group_name = var.logAnalyticsWorkspaceResourceGroupName
}