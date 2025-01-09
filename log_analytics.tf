resource "azurerm_log_analytics_workspace" "main" {
  count = local.create_analytics_workspace ? 1 : 0

  location                                = coalesce(var.location, data.azurerm_resource_group.main.location)
  name                                    = coalesce(var.cluster_log_analytics_workspace_name, trim("${var.prefix}-workspace", "-"))
  resource_group_name                     = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  allow_resource_only_permissions         = var.log_analytics_workspace_allow_resource_only_permissions
  cmk_for_query_forced                    = var.log_analytics_workspace_cmk_for_query_forced
  daily_quota_gb                          = var.log_analytics_workspace_daily_quota_gb
  data_collection_rule_id                 = var.log_analytics_workspace_data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.log_analytics_workspace_immediate_data_purge_on_30_days_enabled
  internet_ingestion_enabled              = var.log_analytics_workspace_internet_ingestion_enabled
  internet_query_enabled                  = var.log_analytics_workspace_internet_query_enabled
  local_authentication_disabled           = var.log_analytics_workspace_local_authentication_disabled
  reservation_capacity_in_gb_per_day      = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  retention_in_days                       = var.log_retention_in_days
  sku                                     = var.log_analytics_workspace_sku
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "e3dd48ea03e7fd9955145d5e1b985fb501c49d91"
    avm_git_file             = "log_analytics.tf"
    avm_git_last_modified_at = "2024-05-20 06:53:31"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "f58cfe56-cff2-4552-8bf7-07e998fa28f3"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  dynamic "identity" {
    for_each = var.log_analytics_workspace_identity == null ? [] : [var.log_analytics_workspace_identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

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
    avm_yor_trace            = "5bcf0000-2dc6-441a-9825-6d582659aeb7"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "main"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

locals {
  dcr_location = try(coalesce(try(local.log_analytics_workspace.location, null), try(data.azurerm_log_analytics_workspace.main[0].location, null)), null)
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  count               = (var.log_analytics_workspace_enabled && var.oms_agent_enabled) ? 1 : 0
  name                = "MSCI-${local.dcr_location}-${azurerm_kubernetes_cluster.main.name}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = local.dcr_location
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = local.log_analytics_workspace.id
      name                  = local.log_analytics_workspace.name
    }
  }

  data_flow {
    streams      = var.streams
    destinations = [local.log_analytics_workspace.name]
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = [local.log_analytics_workspace.name]
  }

  data_sources {
    syslog {
      streams        = ["Microsoft-Syslog"]
      facility_names = var.syslog_facilities
      log_levels     = var.syslog_levels
      name           = "sysLogsDataSource"
    }

    extension {
      streams        = var.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : var.data_collection_settings.data_collection_interval,
          "namespaceFilteringMode" : var.data_collection_settings.namespace_filtering_mode_for_data_collection,
          "namespaces" : var.data_collection_settings.namespaces_for_data_collection,
          "enableContainerLogV2" : var.data_collection_settings.container_log_v2_enabled,
        }
      })
      name = "ContainerInsightsExtension"
    }
  }

  description = "DCR for Azure Monitor Container Insights"
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  count                   = (var.log_analytics_workspace_enabled && var.oms_agent_enabled) ? 1 : 0
  name                    = "ContainerInsightsExtension"
  target_resource_id      = azurerm_kubernetes_cluster.main.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr[0].id
  description             = "Association of container insights data collection rule. Deleting this association will break the data collection for this AKS Cluster."
}