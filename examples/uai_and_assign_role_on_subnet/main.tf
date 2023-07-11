resource "random_pet" "this" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.resource_group_name}-${random_pet.this.id}"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  name                = "vnet"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["192.168.0.0/24"]
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_user_assigned_identity" "main" {
  location            = azurerm_resource_group.rg.location
  name                = "uami-${var.kubernetes_cluster_name}"
  resource_group_name = azurerm_resource_group.rg.name
}

module "aks" {
  source = "../../"

  cluster_name        = var.kubernetes_cluster_name
  prefix              = var.kubernetes_cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  identity_ids        = [azurerm_user_assigned_identity.main.id]
  identity_type       = "UserAssigned"
  vnet_subnet_id      = azurerm_subnet.subnet.id
  rbac_aad            = false
  network_contributor_role_assigned_subnet_ids = {
    vnet_subnet = azurerm_subnet.subnet.id
  }
}