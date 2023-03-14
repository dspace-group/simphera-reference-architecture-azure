terraform {
  required_version = ">= 1.0.0"
}

locals {
  log_analytics_enabled = var.logAnalyticsWorkspaceName != "" ? true : false
}
