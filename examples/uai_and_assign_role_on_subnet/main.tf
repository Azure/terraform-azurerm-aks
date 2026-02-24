data "azapi_client_config" "current" {}

resource "azapi_resource_action" "register_encryption_at_host" {
  type        = "Microsoft.Compute/features@2021-07-01"
  resource_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/providers/Microsoft.Features/providers/Microsoft.Compute/features/EncryptionAtHost"
  action      = "register"
  method      = "POST"
}

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

  location            = azurerm_resource_group.rg.location
  cluster_name        = var.kubernetes_cluster_name
  prefix              = var.kubernetes_cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  identity_ids        = [azurerm_user_assigned_identity.main.id]
  identity_type       = "UserAssigned"
  rbac_aad_tenant_id  = data.azurerm_client_config.this.tenant_id
  vnet_subnet = {
    id = azurerm_subnet.subnet.id
  }
  network_contributor_role_assigned_subnet_ids = {
    vnet_subnet = azurerm_subnet.subnet.id
  }

  depends_on = [
    azapi_resource_action.register_encryption_at_host,
  ]
}