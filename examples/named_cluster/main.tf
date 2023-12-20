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

resource "azurerm_user_assigned_identity" "test" {
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-identity"
  resource_group_name = local.resource_group.name
}

# Just for demo purpose, not necessary to named cluster.
resource "azurerm_log_analytics_workspace" "main" {
  location            = coalesce(var.log_analytics_workspace_location, local.resource_group.location)
  name                = "prefix-workspace"
  resource_group_name = local.resource_group.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "main" {
  location              = coalesce(var.log_analytics_workspace_location, local.resource_group.location)
  resource_group_name   = local.resource_group.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

module "aks_cluster_name" {
  source = "../.."

  prefix                               = "prefix"
  resource_group_name                  = local.resource_group.name
  admin_username                       = null
  azure_policy_enabled                 = true
  cluster_log_analytics_workspace_name = "test-cluster"
  cluster_name                         = "test-cluster"
  disk_encryption_set_id               = azurerm_disk_encryption_set.des.id
  identity_ids                         = [azurerm_user_assigned_identity.test.id]
  identity_type                        = "UserAssigned"
  log_analytics_solution = {
    id = azurerm_log_analytics_solution.main.id
  }
  log_analytics_workspace_enabled = true
  log_analytics_workspace = {
    id   = azurerm_log_analytics_workspace.main.id
    name = azurerm_log_analytics_workspace.main.name
  }
  maintenance_window = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = []
  }
  net_profile_pod_cidr              = "10.1.0.0/16"
  private_cluster_enabled           = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true

  # KMS etcd encryption
  kms_enabled                  = true
  kms_key_vault_key_id         = azurerm_key_vault_key.kms.id
  kms_key_vault_network_access = "Private"

  depends_on = [
    azurerm_key_vault_access_policy.kms,
    azurerm_role_assignment.kms
  ]
}
