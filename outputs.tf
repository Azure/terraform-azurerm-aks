output "client_key" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].host
}

output "username" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].username
}

output "password" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].password
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.main.node_resource_group
}

output "location" {
  value = azurerm_kubernetes_cluster.main.location
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "kube_config_raw" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
}

output "kube_admin_config_raw" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_admin_config_raw
}

output "http_application_routing_zone_name" {
  value = length(azurerm_kubernetes_cluster.main.addon_profile) > 0 && length(azurerm_kubernetes_cluster.main.addon_profile[0].http_application_routing) > 0 ? azurerm_kubernetes_cluster.main.addon_profile[0].http_application_routing[0].http_application_routing_zone_name : ""
}

output "system_assigned_identity" {
  value = azurerm_kubernetes_cluster.main.identity
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity
}

output "admin_client_key" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.client_key : ""
}

output "admin_client_certificate" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.client_certificate : ""
}

output "admin_cluster_ca_certificate" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.cluster_ca_certificate : ""
}

output "admin_host" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.host : ""
}

output "admin_username" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.username : ""
}

output "admin_password" {
  value = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config.0.password : ""
}

output "addon_profile" {
  value = try(azurerm_kubernetes_cluster.main.addon_profile.0, null)
}
