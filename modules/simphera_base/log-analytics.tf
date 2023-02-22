data "azurerm_log_analytics_workspace" "log-analytics-workspace" {
  count               = local.log_analytics_enabled ? 1 : 0
  name                = var.logAnalyticsWorkspaceName
  resource_group_name = var.logAnalyticsWorkspaceResourceGroupName
}