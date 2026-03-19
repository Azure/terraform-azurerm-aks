output "aks_id" {
  description = "The ID of the AKS cluster."
  value       = module.aks.aks_id
}

output "aks_name" {
  description = "The name of the AKS cluster."
  value       = module.aks.aks_name
}

output "cluster_private_fqdn" {
  description = "The private FQDN of the AKS cluster."
  value       = module.aks.cluster_private_fqdn
}
