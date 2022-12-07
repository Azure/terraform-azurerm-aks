locals {
  # automatic upgrades are either:
  # - null 
  # - patch, but then the kubernetes_version musnt't specify a patch number
  # - rapid/stable/node-image, but then the kubernetes_version must be null
  automatic_channel_upgrade_check = var.automatic_channel_upgrade == null ? true : (
    contains(["patch"], var.automatic_channel_upgrade) &&
    can(regex("^[0-9]{1,}\\.[0-9]{1,}$", var.kubernetes_version))
    ) == true ? true : (
    contains(["rapid", "stable", "node-image"], var.automatic_channel_upgrade) &&
    var.kubernetes_version == null
  )
  # Abstract the decision whether to create an Analytics Workspace or not.
  create_analytics_solution  = var.log_analytics_workspace_enabled && var.log_analytics_solution_id == null
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
}
