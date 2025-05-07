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

resource "azurerm_subnet" "default_node_pool_subnet" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${random_id.prefix.hex}-defaultsn"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
}

resource "azurerm_subnet" "node_pool_subnet" {
  count                = 3
  address_prefixes     = ["10.52.${count.index + 1}.0/24"]
  name                 = "${random_id.prefix.hex}-sn${count.index}"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
}

locals {
  nodes = {
    for i in range(3) : "worker${i}" => {
      name                  = substr("worker${i}${random_id.prefix.hex}", 0, 8)
      vm_size               = "Standard_D2s_v3"
      node_count            = 1
      vnet_subnet           = { id = azurerm_subnet.node_pool_subnet[i].id }
      create_before_destroy = i % 2 == 0
    }
  }
}

module "aks" {
  source = "../.."

  prefix                  = "prefix-${random_id.prefix.hex}"
  resource_group_name     = local.resource_group.name
  location                = local.resource_group.location
  os_disk_size_gb         = 60
  rbac_aad                = true
  sku_tier                = "Standard"
  private_cluster_enabled = false
  vnet_subnet = {
    id = azurerm_subnet.default_node_pool_subnet.id
  }
  node_pools                                 = local.nodes
  kubernetes_version                         = var.kubernetes_version
  orchestrator_version                       = var.orchestrator_version
  create_role_assignment_network_contributor = true
}
