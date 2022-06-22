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

output "cluster_identity" {
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

output "aci_connector_linux" {
  value = try(azurerm_kubernetes_cluster.main.aci_connector_linux[0], null)
}

output "aci_connector_linux_enabled" {
  value = can(azurerm_kubernetes_cluster.main.aci_connector_linux[0])
}

output "azure_policy_enabled" {
  value = azurerm_kubernetes_cluster.main.azure_policy_enabled
}

output "http_application_routing_enabled" {
  value = azurerm_kubernetes_cluster.main.http_application_routing_enabled
}

output "ingress_application_gateway" {
  value = try(azurerm_kubernetes_cluster.main.ingress_application_gateway[0], null)
}

output "ingress_application_gateway_enabled" {
  value = can(azurerm_kubernetes_cluster.main.ingress_application_gateway[0])
}

output "key_vault_secrets_provider" {
  value = try(azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0], null)
}

output "key_vault_secrets_provider_enabled" {
  value = can(azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0])
}

output "oms_agent" {
  value = try(azurerm_kubernetes_cluster.main.oms_agent[0], null)
}

output "oms_agent_enabled" {
  value = can(azurerm_kubernetes_cluster.main.oms_agent[0])
}

output "open_service_mesh_enabled" {
  value = azurerm_kubernetes_cluster.main.open_service_mesh_enabled
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "generated_cluster_public_ssh_key" {
  description = "The cluster will use this generated public key as ssh key when `var.public_ssh_key` is empty or null."
  value       = try(azurerm_kubernetes_cluster.main.linux_profile[0], null) != null ? (var.public_ssh_key == "" || var.public_ssh_key == null ? tls_private_key.ssh.public_key_openssh : null) : null
}

output "generated_cluster_private_ssh_key" {
  description = "The cluster will use this generated private key as ssh key when `var.public_ssh_key` is empty or null."
  sensitive   = true
  value       = try(azurerm_kubernetes_cluster.main.linux_profile[0], null) != null ? (var.public_ssh_key == "" || var.public_ssh_key == null ? tls_private_key.ssh.private_key_pem : null) : null
}