

locals {
  log_analytics_enabled = var.logAnalyticsWorkspaceName != "" ? true : false
}
