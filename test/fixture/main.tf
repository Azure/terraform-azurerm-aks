# Modules
module "aks_private" {
  source                             = "../.."
  cluster_name                       = "test-cluster-with-acr"
  resource_group_name                = azurerm_resource_group.main.name
  network_plugin                     = "azure"
  vnet_subnet_id                     = azurerm_subnet.aks_private.id
  sku_tier                           = "Paid"
  enable_auto_scaling                = true
  min_count                          = 1
  max_count                          = 3
  node_count                         = 1
  max_pods                           = 110
  default_node_pool_name             = "testnodepool"
  zones                              = [1, 2, 3]
  type                               = "VirtualMachineScaleSets"
  key_vault_secrets_provider_enabled = false
  azure_container_registry_id        = azurerm_container_registry.main.id
  azure_container_registry_enabled   = false
  private_cluster_enabled            = true
  depends_on                         = [azurerm_resource_group.main]

  node_labels = {
    "private" = "yes"
  }

  node_tags = {
    "private" = "yes"
  }
}

module "aks_kubenet" {
  source                          = "../.."
  prefix                          = "aks-${random_id.prefix.hex}"
  resource_group_name             = azurerm_resource_group.main.name
  network_plugin                  = "kubenet"
  log_analytics_workspace_enabled = true
  log_analytics_solution_enabled  = true
  log_analytics_workspace_name    = "test-log-workspace"
  pod_cidr                        = "10.1.0.0/16"
  depends_on                      = [azurerm_resource_group.main]

  node_labels = {
    "private" = "no"
  }

  node_tags = {
    "private" = "no"
  }
}

# Resources
resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  name     = "${random_id.prefix.hex}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "aks_private" {
  name                = "${random_id.prefix.hex}-vn"
  address_space       = ["10.53.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "aks_private" {
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.aks_private.name
  address_prefixes     = ["10.53.0.0/24"]
}

resource "azurerm_user_assigned_identity" "test" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${random_id.prefix.hex}-identity"
}

resource "azurerm_container_registry" "main" {
  name                = "${random_id.prefix.hex}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  admin_enabled       = false
}