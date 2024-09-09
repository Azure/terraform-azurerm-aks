resource "azurerm_kubernetes_cluster" "main" {
  # tflint-ignore: azurerm_resource_tag
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_os_channel_upgrade   = var.node_os_channel_upgrade
}