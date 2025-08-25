resource "azurerm_subnet" "default_node_pool_subnet" {
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "node_pool_subnet" {
  enforce_private_link_endpoint_network_policies = true
}