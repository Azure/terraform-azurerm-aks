output "test_aks_without_monitor_id" {
  value = module.aks_without_monitor.aks_id
}

output "test_aks_without_monitor_identity" {
  sensitive = true
  value     = try(module.aks_without_monitor.cluster_identity, "")
}
