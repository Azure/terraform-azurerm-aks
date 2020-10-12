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

module aks {
  source                          = "../.."
  prefix                          = "prefix-${random_id.prefix.hex}"
  resource_group_name             = azurerm_resource_group.main.name
  client_id                       = var.client_id
  client_secret                   = var.client_secret
  vnet_subnet_id                  = azurerm_subnet.test.id
  os_disk_size_gb                 = 60
  enable_http_application_routing = true
  depends_on                      = [azurerm_resource_group.main]
}

module aks_paid_sku {
  source                          = "../.."
  prefix                          = "prefix3-${random_id.prefix.hex}"
  resource_group_name             = azurerm_resource_group.main.name
  sku_tier                        = "Paid"
  depends_on                      = [azurerm_resource_group.main]
}

module aks_without_monitor {
  source                         = "../.."
  prefix                         = "prefix2-${random_id.prefix.hex}"
  resource_group_name            = azurerm_resource_group.main.name
  enable_log_analytics_workspace = false
  depends_on                     = [azurerm_resource_group.main]
}
