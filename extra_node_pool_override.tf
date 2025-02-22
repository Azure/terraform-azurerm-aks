# tflint-ignore-file: azurerm_resource_tag

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_before_destroy" {
  custom_ca_trust_enabled = each.value.custom_ca_trust_enabled
  enable_auto_scaling     = each.value.enable_auto_scaling
  enable_host_encryption  = each.value.enable_host_encryption
  enable_node_public_ip   = each.value.enable_node_public_ip
  message_of_the_day      = each.value.message_of_the_day
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_after_destroy" {
  custom_ca_trust_enabled = each.value.custom_ca_trust_enabled
  enable_auto_scaling     = each.value.enable_auto_scaling
  enable_host_encryption  = each.value.enable_host_encryption
  enable_node_public_ip   = each.value.enable_node_public_ip
  message_of_the_day      = each.value.message_of_the_day
}