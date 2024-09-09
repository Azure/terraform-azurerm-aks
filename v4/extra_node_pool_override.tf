# tflint-ignore-file: azurerm_resource_tag

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_before_destroy" {
  auto_scaling_enabled    = each.value.enable_auto_scaling
  host_encryption_enabled = each.value.enable_host_encryption
  node_public_ip_enabled  = each.value.enable_node_public_ip
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_after_destroy" {
  auto_scaling_enabled    = each.value.enable_auto_scaling
  host_encryption_enabled = each.value.enable_host_encryption
  node_public_ip_enabled  = each.value.enable_node_public_ip
}