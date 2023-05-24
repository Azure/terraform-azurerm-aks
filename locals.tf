locals {
  # Abstract if auto_scaler_profile_scale_down_delay_after_delete is not set or null we should use the scan_interval.
  auto_scaler_profile_scale_down_delay_after_delete = var.auto_scaler_profile_scale_down_delay_after_delete == null ? var.auto_scaler_profile_scan_interval : var.auto_scaler_profile_scale_down_delay_after_delete
  # automatic upgrades are either:
  # - null
  # - patch, but then neither the kubernetes_version nor orchestrator_version must specify a patch number, where orchestrator_version may be also null
  # - rapid/stable/node-image, but then the kubernetes_version and the orchestrator_version must be null
  automatic_channel_upgrade_check = var.automatic_channel_upgrade == null ? true : (
    (contains(["patch"], var.automatic_channel_upgrade) && can(regex("^[0-9]{1,}\\.[0-9]{1,}$", var.kubernetes_version)) && (can(regex("^[0-9]{1,}\\.[0-9]{1,}$", var.orchestrator_version)) || var.orchestrator_version == null)) ||
    (contains(["rapid", "stable", "node-image"], var.automatic_channel_upgrade) && var.kubernetes_version == null && var.orchestrator_version == null)
  )
  # Abstract the decision whether to create an Analytics Workspace or not.
  create_analytics_solution  = var.log_analytics_workspace_enabled && var.log_analytics_solution == null
  create_analytics_workspace = var.log_analytics_workspace_enabled && var.log_analytics_workspace == null
  # Abstract the decision whether to use an Analytics Workspace supplied via vars, provision one ourselves or leave it null.
  # This guarantees that local.log_analytics_workspace will contain a valid `id` and `name` IFF log_analytics_workspace_enabled
  # is set to `true`.
  log_analytics_workspace = var.log_analytics_workspace_enabled ? (
    # The Log Analytics Workspace should be enabled:
    var.log_analytics_workspace == null ? {
      # `log_analytics_workspace_enabled` is `true` but `log_analytics_workspace` was not supplied.
      # Create an `azurerm_log_analytics_workspace` resource and use that.
      id   = local.azurerm_log_analytics_workspace_id
      name = local.azurerm_log_analytics_workspace_name
      } : {
      # `log_analytics_workspace` is supplied. Let's use that.
      id   = var.log_analytics_workspace.id
      name = var.log_analytics_workspace.name
    }
  ) : null # Finally, the Log Analytics Workspace should be disabled.
  potential_subnet_ids = flatten(concat([
    for pool in var.node_pools : [
      pool.vnet_subnet_id,
      pool.pod_subnet_id
    ]
  ], [var.vnet_subnet_id]))
  subnet_ids = toset([for id in local.potential_subnet_ids : id if id != null])
}

