# tflint-ignore-file: azurerm_resource_tag

resource "azurerm_kubernetes_cluster" "main" {
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_os_channel_upgrade   = var.node_os_channel_upgrade
}