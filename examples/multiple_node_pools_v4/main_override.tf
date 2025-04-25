resource "azurerm_subnet" "default_node_pool_subnet" {
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "node_pool_subnet" {
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

module "aks" {
  source = "../../v4"
}