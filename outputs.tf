output "client_key" {
  value = module.kubernetes.client_key
}

output "client_certificate" {
  value = module.kubernetes.client_certificate
}

output "cluster_ca_certificate" {
  value = module.kubernetes.cluster_ca_certificate
}

output "host" {
  value = module.kubernetes.host
}

output "username" {
  value = module.kubernetes.username
}

output "password" {
  value = module.kubernetes.password
}

output "node_resource_group" {
  value = module.kubernetes.node_resource_group
}

output "location" {
  value = module.kubernetes.location
}

output "azurerm_log_analytics_solution_id" {
  value = azurerm_log_analytics_solution.main.id
}

output "azurerm_log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "azurerm_log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}


