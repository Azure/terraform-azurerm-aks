# AKS Kubenet
output "aks_kubenet_aks_id" {
  value = module.aks_kubenet.aks_id
}

output "aks_kubenet_kube_config_raw" {
  value     = module.aks_kubenet.kube_config_raw
  sensitive = true
}

# Private AKS with Azure CNI and ACR
output "aks_private_aks_id" {
  value = module.aks_private.aks_id
}

output "aks_private_identity" {
  value = module.aks_private.identity
}