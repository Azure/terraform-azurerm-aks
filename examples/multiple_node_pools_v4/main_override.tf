resource "azurerm_subnet" "test" {
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

module "aks" {
  source = "../../v4"
}