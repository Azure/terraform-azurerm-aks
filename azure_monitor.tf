resource "azapi_resource_action" "enable_azure_monitor_metrics" {
  count       = var.azure_monitor_workspace_enabled && var.azure_monitor_workspace_resource_id != null ? 1 : 0
  type        = "Microsoft.ContainerService/managedClusters@2023-01-01"
  resource_id = azurerm_kubernetes_cluster.main.id
  action      = "enableMonitoringMetrics"
  method      = "POST"
  
  body = jsonencode({
    properties = {
      azureMonitorWorkspaceResourceId = var.azure_monitor_workspace_resource_id
      grafanaResourceId               = var.grafana_enabled && var.grafana_resource_id != null ? var.grafana_resource_id : null
    }
  })

  depends_on = [azurerm_kubernetes_cluster.main]
}