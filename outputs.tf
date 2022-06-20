output "client_key" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].client_key
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
}

output "cluster_ca_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
}

output "host" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].host
}

output "username" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].username
}

output "password" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config[0].password
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
  value = azurerm_kubernetes_cluster.main.http_application_routing_zone_name != null ? azurerm_kubernetes_cluster.main.http_application_routing_zone_name : ""
}

output "system_assigned_identity" {
  value = azurerm_kubernetes_cluster.main.identity
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity
}

output "admin_client_key" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key, "")
}

output "admin_client_certificate" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate, "")
}

output "admin_cluster_ca_certificate" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate, "")
}

output "admin_host" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].host, "")
}

output "admin_username" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].username, "")
}

output "admin_password" {
  value = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].password, "")
}

output "addon_profile" {
  value = {
    aci_connector_linux                 = try(azurerm_kubernetes_cluster.main.aci_connector_linux[0], null)
    aci_connector_linux_enabled         = can(azurerm_kubernetes_cluster.main.aci_connector_linux[0])
    azure_policy_enabled                = azurerm_kubernetes_cluster.main.azure_policy_enabled
    http_application_routing_enabled    = azurerm_kubernetes_cluster.main.http_application_routing_enabled
    ingress_application_gateway         = try(azurerm_kubernetes_cluster.main.ingress_application_gateway[0], null)
    ingress_application_gateway_enabled = can(azurerm_kubernetes_cluster.main.ingress_application_gateway[0])
    key_vault_secrets_provider          = try(azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0], null)
    key_vault_secrets_provider_enabled  = can(azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0])
    oms_agent                           = try(azurerm_kubernetes_cluster.main.oms_agent[0], null)
    oms_agent_enabled                   = can(azurerm_kubernetes_cluster.main.oms_agent[0])
    open_service_mesh_enabled           = azurerm_kubernetes_cluster.main.open_service_mesh_enabled
  }
}
