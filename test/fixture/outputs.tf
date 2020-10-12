output "test_aks_id" {
  value = module.aks.aks_id
}

output "test_aks_without_monitor_id" {
  value = module.aks_without_monitor.aks_id
}

output "test_aks_without_monitor_identity" {
  value = module.aks_without_monitor.system_assigned_identity
}
