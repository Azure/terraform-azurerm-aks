output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.main.node_resource_group
  description = "The name of the Resource Group where the Kubernetes Nodes should exist."
}

output "location" {
  value       = azurerm_kubernetes_cluster.main.location
  description = "The location where the Managed Kubernetes Cluster is created."
}

output "aks_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "The Kubernetes Managed Cluster ID."
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
}

output "kube_admin_config_raw" {
  value       = azurerm_kubernetes_cluster.main.kube_admin_config_raw
  description = "Raw Kubernetes config for the admin account to be used by kubectl and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled."
}

output "http_application_routing_zone_name" {
  value       = try(azurerm_kubernetes_cluster.main.http_application_routing_zone_name, null)
  description = "The Zone Name of the HTTP Application Routing."
}

output "identity" {
  value = {
    "principal_id" = azurerm_kubernetes_cluster.main.identity[0].principal_id
    "tenant_id"    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  }
  description = "The Principal and Tenant IDs associated with this Managed Service Identity."
}

output "kubelet_identity" {
  value = {
    "client_id"                 = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
    "object_id"                 = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
    "user_assigned_identity_id" = azurerm_kubernetes_cluster.main.kubelet_identity[0].user_assigned_identity_id
  }
  description = "The Client, Object and User Assigned Identity IDs of the Managed Identity to be assigned to the Kubelets."
}

output "kube_admin_config" {
  value = {
    "client_key"             = azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key
    "client_certificate"     = azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate
    "cluster_ca_certificate" = azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate
    "host"                   = azurerm_kubernetes_cluster.main.kube_admin_config[0].host
    "username"               = azurerm_kubernetes_cluster.main.kube_admin_config[0].username
    "password"               = azurerm_kubernetes_cluster.main.kube_admin_config[0].password
  }
  description = "Map of credentials to authenticate to Kubernetes as an administrator."
}

output "kube_config" {
  value = {
    "client_key"             = azurerm_kubernetes_cluster.main.kube_config[0].client_key
    "client_certificate"     = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
    "cluster_ca_certificate" = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
    "host"                   = azurerm_kubernetes_cluster.main.kube_config[0].host
    "username"               = azurerm_kubernetes_cluster.main.kube_config[0].username
    "password"               = azurerm_kubernetes_cluster.main.kube_config[0].password
  }
  description = "Map of credentials to authenticate to Kubernetes as a user."
}

output "private_key" {
  value = var.public_ssh_key != null ? {
    "private_key_pem"     = tls_private_key.main.private_key_pem
    "private_key_openssh" = tls_private_key.main.private_key_openssh
  } : {}
  description = "Private key data in PEM (RFC 1421) and OpenSSH PEM (RFC 4716) format."
}

output "public_key" {
  value = var.public_ssh_key != null ? {
    "public_key_pem"     = tls_private_key.main.public_key_pem
    "public_key_openssh" = tls_private_key.main.public_key_openssh
  } : {}
  description = "Public key data in PEM (RFC 1421) and [Authorized Keys](https://www.ssh.com/academy/ssh/authorized_keys/openssh#format-of-the-authorized-keys-file) format."
}

output "log_analytics_workspace_id" {
  value       = var.log_analytics_workspace_enabled ? azurerm_log_analytics_workspace.main[0].id : ""
  description = "The Log Analytics Workspace ID."
}