output "cluster_id" {
  value = "${azurerm_kubernetes_cluster.main.id}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.host}"
}

output "username" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.username}"
}

output "password" {
  value = "${azurerm_kubernetes_cluster.main.kube_config.0.password}"
}

output "raw_kube_config" {
  value = "${azurerm_kubernetes_cluster.main.kube_config_raw}"
}

output "http_application_routing_zone_name" {
  value = "${azurerm_kubernetes_cluster.main.addon_profile.0.http_application_routing.0.http_application_routing_zone_name}"
}
