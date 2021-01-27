// we need a network, subnet, service principal and loging workspace

provider "azurerm" {
  features {}
}


resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  name     = "${random_id.prefix.hex}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "test" {
  name                = "${random_id.prefix.hex}-vn"
  address_space       = ["10.52.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "test" {
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.52.0.0/24"]
}
resource "azuread_application" "this" {
  display_name            = "${random_id.prefix.hex}-sp"
  group_membership_claims = "All"
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "start-sleep 30"
  }
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  value                = random_id.prefix.hex
  end_date             = "2099-01-01T01:02:03Z"

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "start-sleep 30"
  }
}
