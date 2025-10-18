output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.aks_name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.aks_id
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster"
  value       = module.aks.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the cluster"
  value       = module.aks.client_key
  sensitive   = true
}

output "host" {
  description = "The Kubernetes cluster server host"
  value       = module.aks.host
  sensitive   = true
}

output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "localdns_config" {
  description = "LocalDNS configuration applied to the cluster"
  value       = module.aks.localdns_config
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = local.resource_group.name
}

output "subnet_id" {
  description = "ID of the subnet used by the AKS cluster"
  value       = azurerm_subnet.test.id
}

output "vnet_id" {
  description = "ID of the virtual network used by the AKS cluster"
  value       = azurerm_virtual_network.test.id
}