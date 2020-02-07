resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  name     = "${random_id.prefix.hex}-rg"
  location = var.location
}

module aks {
  resource_group_name = azurerm_resource_group.main.name
  source              = "../.."
  prefix              = "pre${random_id.prefix.hex}"
  client_id           = var.client_id
  client_secret       = var.client_secret
}
