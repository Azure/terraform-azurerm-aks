# AKS Azure CNI
output "module_aks_azure_cni_aks_id" {
  value = module.aks_azure_cni[*].aks_id
}

output "module_aks_azure_cni_kube_config_raw" {
  value     = module.aks_kubenet[*].kube_config_raw
  sensitive = true
}

# AKS Kubenet
output "module_aks_kubenet_aks_id" {
  value = module.aks_kubenet[*].aks_id
}

output "module_aks_kubenet_kube_config_raw" {
  value     = module.aks_kubenet[*].kube_config_raw
  sensitive = true
}