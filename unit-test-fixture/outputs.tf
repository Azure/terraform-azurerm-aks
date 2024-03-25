output "create_analytics_solution" {
  value = local.create_analytics_solution
}

output "create_analytics_workspace" {
  value = local.create_analytics_workspace
}

output "log_analytics_workspace" {
  value = local.log_analytics_workspace
}

output "automatic_channel_upgrade_check" {
  value = local.automatic_channel_upgrade_check
}

output "auto_scaler_profile_scale_down_delay_after_delete" {
  value = local.auto_scaler_profile_scale_down_delay_after_delete
}

output "auto_scaler_profile_scan_interval" {
  value = var.auto_scaler_profile_scan_interval
}

output "query_datasource_for_log_analytics_workspace_location" {
  value = local.query_datasource_for_log_analytics_workspace_location
}