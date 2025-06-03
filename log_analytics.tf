resource "azurerm_log_analytics_workspace" "main" {
  count = local.create_analytics_workspace ? 1 : 0

  location                                = var.location
  name                                    = try(coalesce(var.cluster_log_analytics_workspace_name, trim("${var.prefix}-workspace", "-")), "aks-workspace")
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
  tags                                    = var.tags

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
  tags                  = var.tags

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

locals {
  dcr_location = try(coalesce(try(local.log_analytics_workspace.location, null), try(data.azurerm_log_analytics_workspace.main[0].location, null)), null)
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  count = local.create_analytics_workspace && var.oms_agent_enabled && var.create_monitor_data_collection_rule ? 1 : 0

  location            = local.dcr_location
  name                = "MSCI-${local.dcr_location}-${azurerm_kubernetes_cluster.main.name}"
  resource_group_name = var.resource_group_name
  description         = "DCR for Azure Monitor Container Insights"
  tags                = var.tags

  data_flow {
    destinations = [local.log_analytics_workspace.name]
    streams      = var.monitor_data_collection_rule_extensions_streams
  }
  data_flow {
    destinations = [local.log_analytics_workspace.name]
    streams      = ["Microsoft-Syslog"]
  }
  destinations {
    log_analytics {
      name                  = local.log_analytics_workspace.name
      workspace_resource_id = local.log_analytics_workspace.id
    }
  }
  data_sources {
    extension {
      extension_name = "ContainerInsights"
      name           = "ContainerInsightsExtension"
      streams        = var.monitor_data_collection_rule_extensions_streams
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          interval               = var.data_collection_settings.data_collection_interval
          namespaceFilteringMode = var.data_collection_settings.namespace_filtering_mode_for_data_collection
          namespaces             = var.data_collection_settings.namespaces_for_data_collection
          enableContainerLogV2   = var.data_collection_settings.container_log_v2_enabled
        }
      })
    }
    syslog {
      facility_names = var.monitor_data_collection_rule_data_sources_syslog_facilities
      log_levels     = var.monitor_data_collection_rule_data_sources_syslog_levels
      name           = "sysLogsDataSource"
      streams        = ["Microsoft-Syslog"]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  count = local.create_analytics_workspace && var.oms_agent_enabled && var.create_monitor_data_collection_rule ? 1 : 0

  target_resource_id      = azurerm_kubernetes_cluster.main.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr[0].id
  description             = "Association of container insights data collection rule. Deleting this association will break the data collection for this AKS Cluster."
  name                    = "ContainerInsightsExtension"
}