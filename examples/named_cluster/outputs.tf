output "test_aks_named_id" {
  value = module.aks_cluster_name.aks_id
}

output "test_aks_named_identity" {
  sensitive = true
  value     = try(module.aks_cluster_name.cluster_identity, "")
}
