resource "azurerm_log_analytics_workspace" "main" {
  count = local.create_analytics_workspace ? 1 : 0

  location            = coalesce(var.location, data.azurerm_resource_group.main.location)
  name                = coalesce(var.cluster_log_analytics_workspace_name, trim("${var.prefix}-workspace", "-"))
  resource_group_name = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  retention_in_days   = var.log_retention_in_days
  sku                 = var.log_analytics_workspace_sku
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "0ae8a663f1dc1dc474b14c10d9c94c77a3d1e234"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-06-05 02:21:33"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "e82d0232-9269-4448-9c24-df1e6f7b78aa"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  lifecycle {
    precondition {
      condition     = can(coalesce(var.cluster_log_analytics_workspace_name, var.prefix))
      error_message = "You must set one of `var.cluster_log_analytics_workspace_name` and `var.prefix` to create `azurerm_log_analytics_workspace.main`."
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
    avm_yor_trace            = "c84a7e35-ea32-4898-be71-574ee3a76cb1"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}
