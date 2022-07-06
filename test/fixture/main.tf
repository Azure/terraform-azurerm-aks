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

resource "azurerm_user_assigned_identity" "test" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${random_id.prefix.hex}-identity"
}

module "aks" {
  source                           = "../.."
  prefix                           = "prefix-${random_id.prefix.hex}"
  resource_group_name              = azurerm_resource_group.main.name
  client_id                        = var.client_id
  client_secret                    = var.client_secret
  network_plugin                   = "azure"
  vnet_subnet_id                   = azurerm_subnet.test.id
  os_disk_size_gb                  = 60
  enable_http_application_routing  = true
  azure_policy_enabled             = true
  enable_host_encryption           = true
  enable_role_based_access_control = true
  rbac_aad_managed                 = true
  enable_log_analytics_workspace   = true
  sku_tier                         = "Paid"
  private_cluster_enabled          = true
  enable_auto_scaling              = true
  agents_min_count                 = 1
  agents_max_count                 = 2
  agents_count                     = null
  agents_max_pods                  = 100
  agents_pool_name                 = "testnodepool"
  agents_availability_zones        = ["1", "2"]
  agents_type                      = "VirtualMachineScaleSets"

  agents_labels = {
    "node1" : "label1"
  }

  agents_tags = {
    "Agent" : "agentTag"
  }

  enable_ingress_application_gateway      = true
  ingress_application_gateway_name        = "${random_id.prefix.hex}-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [azurerm_resource_group.main]
}

module "aks_without_monitor" {
  source                           = "../.."
  prefix                           = "prefix2-${random_id.prefix.hex}"
  resource_group_name              = azurerm_resource_group.main.name
  enable_role_based_access_control = true
  rbac_aad_managed                 = true
  #checkov:skip=CKV_AZURE_4:The logging is turn off for demo purpose. DO NOT DO THIS IN PRODUCTION ENVIRONMENT!
  enable_log_analytics_workspace   = false
  net_profile_pod_cidr             = "10.1.0.0/16"
  depends_on                       = [azurerm_resource_group.main]
}

module "aks_cluster_name" {
  source                               = "../.."
  cluster_name                         = "test-cluster"
  prefix                               = "prefix"
  resource_group_name                  = azurerm_resource_group.main.name
  enable_role_based_access_control     = true
  rbac_aad_managed                     = true
  enable_log_analytics_workspace       = true
  # Not necessary, just for demo purpose.
  admin_username                       = "azureuser"
  cluster_log_analytics_workspace_name = "test-cluster"
  net_profile_pod_cidr                 = "10.1.0.0/16"
  identity_type                        = "UserAssigned"
  identity_ids                         = [azurerm_user_assigned_identity.test.id]
  depends_on                           = [azurerm_resource_group.main]
}
