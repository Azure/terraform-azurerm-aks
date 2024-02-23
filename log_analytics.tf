resource "azurerm_log_analytics_workspace" "main" {
  count = local.create_analytics_workspace ? 1 : 0

  location                                = coalesce(var.new_log_analytics_workspace.location, var.location, data.azurerm_resource_group.main.location)
  name                                    = coalesce(var.new_log_analytics_workspace.name, trim("${var.prefix}-workspace", "-"))
  resource_group_name                     = coalesce(var.new_log_analytics_workspace.resource_group_name, var.resource_group_name)
  allow_resource_only_permissions         = var.new_log_analytics_workspace.allow_resource_only_permissions
  cmk_for_query_forced                    = var.new_log_analytics_workspace.cmk_for_query_forced
  daily_quota_gb                          = var.new_log_analytics_workspace.daily_quota_gb
  data_collection_rule_id                 = var.new_log_analytics_workspace.data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.new_log_analytics_workspace.immediate_data_purge_on_30_days_enabled
  internet_ingestion_enabled              = var.new_log_analytics_workspace.internet_ingestion_enabled
  internet_query_enabled                  = var.new_log_analytics_workspace.internet_query_enabled
  local_authentication_disabled           = var.new_log_analytics_workspace.local_authentication_disabled
  reservation_capacity_in_gb_per_day      = var.new_log_analytics_workspace.reservation_capacity_in_gb_per_day
  retention_in_days                       = var.new_log_analytics_workspace.retention_in_days
  sku                                     = var.new_log_analytics_workspace.sku
  tags = merge(var.tags, var.new_log_analytics_workspace.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "0ae8a663f1dc1dc474b14c10d9c94c77a3d1e234"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-06-05 02:21:33"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "c6fc057f-e58a-46d8-b609-6bdc75ac67b7"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  lifecycle {
    precondition {
      condition     = can(coalesce(var.new_log_analytics_workspace.name, var.prefix))
      error_message = "You must set one of `var.cluster_log_analytics_workspace_name` and `var.prefix` to create `azurerm_log_analytics_workspace.main`."
    }
    precondition {
      condition     = var.log_analytics_workspace == null
      error_message = "You can set only one of `var.log_analytics_workspace` and `var.new_log_analytics_workspace`, not both."
    }
  }
}

locals {
  azurerm_log_analytics_workspace_id                  = try(azurerm_log_analytics_workspace.main[0].id, null)
  azurerm_log_analytics_workspace_location            = try(azurerm_log_analytics_workspace.main[0].location, null)
  azurerm_log_analytics_workspace_name                = try(azurerm_log_analytics_workspace.main[0].name, null)
  azurerm_log_analytics_workspace_resource_group_name = try(azurerm_log_analytics_workspace.main[0].resource_group_name, null)
}

data "azurerm_log_analytics_workspace" "main" {
  count = local.query_datasource_for_log_analytics_workspace_location ? 1 : 0

  name                = var.log_analytics_workspace.name
  resource_group_name = local.log_analytics_workspace.resource_group_name
}

resource "azurerm_log_analytics_solution" "main" {
  count = local.create_analytics_solution ? 1 : 0

  location              = coalesce(local.log_analytics_workspace.location, try(data.azurerm_log_analytics_workspace.main[0].location, null))
  resource_group_name   = local.log_analytics_workspace.resource_group_name
  solution_name         = "ContainerInsights"
  workspace_name        = local.log_analytics_workspace.name
  workspace_resource_id = local.log_analytics_workspace.id
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "886c26d95843149cc2a58ae72edb31478faa2a8c"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-07-20 06:04:07"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "a1d84d17-f05f-4a5e-9252-6085b7e435ab"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}
