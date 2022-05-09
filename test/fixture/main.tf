resource "random_id" "prefix" {
  for_each    = toset(["1", "2", "3"])
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  name     = "${random_id.prefix[1].hex}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "aks_azure_cni" {
  name                = "${random_id.prefix[2].hex}-vn"
  address_space       = ["10.52.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "aks_azure_cni" {
  name                 = "${random_id.prefix[2].hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.aks_azure_cni.name
  address_prefixes     = ["10.52.0.0/24"]
}

resource "azurerm_user_assigned_identity" "test" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${random_id.prefix[1].hex}-identity"
}

module "aks_azure_cni" {
  source                 = "../.."
  prefix                 = "prefix-${random_id.prefix[2].hex}"
  resource_group_name    = azurerm_resource_group.main.name
  network_plugin         = "azure"
  vnet_subnet_id         = azurerm_subnet.aks_azure_cni.id
  sku_tier               = "Paid"
  enable_auto_scaling    = true
  min_count              = 1
  max_count              = 3
  count                  = 1
  max_pods               = 110
  default_node_pool_name = "testnodepool"
  zones                  = [1, 2, 3]
  type                   = "VirtualMachineScaleSets"
  depends_on             = [azurerm_resource_group.main]

  node_labels = {
    "node1" = "label1"
  }

  node_tags = {
    "Agent" = "agentTag"
  }
}

module "aks_kubenet" {
  source                          = "../.."
  cluster_name                    = "test-cluster"
  resource_group_name             = azurerm_resource_group.main.name
  network_plugin                  = "kubenet"
  log_analytics_workspace_enabled = true
  log_analytics_solution_enabled  = true
  log_analytics_workspace_name    = "test-log-workspace"
  pod_cidr                        = "10.1.0.0/16"
  depends_on                      = [azurerm_resource_group.main]
}