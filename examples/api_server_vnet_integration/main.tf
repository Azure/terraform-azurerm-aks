data "azurerm_client_config" "current" {}

resource "random_id" "prefix" {
  byte_length = 8
}

resource "random_id" "name" {
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

resource "azurerm_user_assigned_identity" "aks" {
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-aks-identity"
  resource_group_name = local.resource_group.name
}

resource "azurerm_virtual_network" "main" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vnet"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "nodes" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${random_id.prefix.hex}-nodes-sn"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "api_server" {
  address_prefixes     = ["10.52.1.0/24"]
  name                 = "${random_id.prefix.hex}-apiserver-sn"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name

  delegation {
    name = "aks-api-server-delegation"

    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_role_assignment" "aks_network_contributor_nodes" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.nodes.id
}

resource "azurerm_role_assignment" "aks_network_contributor_api_server" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.api_server.id
}

module "aks" {
  source = "../.."

  location            = local.resource_group.location
  prefix              = random_id.name.hex
  resource_group_name = local.resource_group.name

  # UserAssigned identity required for VNet Integration
  identity_type = "UserAssigned"
  identity_ids  = [azurerm_user_assigned_identity.aks.id]

  # Network configuration
  network_plugin = "azure"
  vnet_subnet = {
    id = azurerm_subnet.nodes.id
  }

  # API Server VNet Integration
  api_server_vnet_integration_enabled = true
  api_server_subnet_id                = azurerm_subnet.api_server.id

  # Private cluster (commonly used with VNet Integration)
  private_cluster_enabled = true

  # Minimal configuration for testing
  rbac_aad_tenant_id                = data.azurerm_client_config.current.tenant_id
  role_based_access_control_enabled = true

  depends_on = [
    azurerm_role_assignment.aks_network_contributor_nodes,
    azurerm_role_assignment.aks_network_contributor_api_server,
  ]
}
