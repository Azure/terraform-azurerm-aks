resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = coalesce(var.resource_group_name, "${random_id.prefix.hex}-rg")
}

locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }
}

resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "test" {
  address_prefixes                               = ["10.52.0.0/24"]
  name                                           = "${random_id.prefix.hex}-sn"
  resource_group_name                            = local.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.test.name
  enforce_private_link_endpoint_network_policies = true
}

resource "random_string" "acr_suffix" {
  length  = 8
  numeric = true
  special = false
  upper   = false
}

resource "azurerm_container_registry" "example" {
  location            = local.resource_group.location
  name                = "aksacrtest${random_string.acr_suffix.result}"
  resource_group_name = local.resource_group.name
  sku                 = "Premium"

  retention_policy {
    days    = 7
    enabled = true
  }
}

module "aks" {
  source = "../.."

  prefix                    = "prefix-${random_id.prefix.hex}"
  resource_group_name       = local.resource_group.name
  kubernetes_version        = "1.26" # don't specify the patch version!
  automatic_channel_upgrade = "patch"
  attached_acr_id_map = {
    example = azurerm_container_registry.example.id
  }
  network_plugin  = "azure"
  network_policy  = "azure"
  os_disk_size_gb = 60
  sku_tier        = "Standard"
  rbac_aad        = false
  vnet_subnet_id  = azurerm_subnet.test.id
}
