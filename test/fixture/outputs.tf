output "test_aks_id" {
  value = module.aks.aks_id
}

output "test_aks_without_monitor_id" {
  value = module.aks_without_monitor.aks_id
}

output "test_aks_without_monitor_identity" {
  value = module.aks_without_monitor.system_assigned_identity
}

output "test_admin_client_key" {
  value = module.aks.admin_client_key
}

output "test_admin_client_certificate" {
  value = module.aks.admin_client_certificate
}

output "test_admin_cluster_ca_certificate" {
  value = module.aks.admin_client_certificate
}

output "test_admin_host" {
  value = module.aks.admin_host
}

output "test_admin_username" {
  value = module.aks.admin_username
}

output "test_admin_password" {
  value = module.aks.admin_password
}

output "test_client_key" {
  value = module.aks.client_key
}

output "test_client_certificate" {
  value = module.aks.client_certificate
}

output "test_cluster_ca_certificate" {
  value = module.aks.client_certificate
}

output "test_host" {
  value = module.aks.host
}

output "test_username" {
  value = module.aks.username
}

output "test_password" {
  value = module.aks.password
}

output "test_kube_raw" {
  sensitive = true
  value     = module.aks.kube_config_raw
}