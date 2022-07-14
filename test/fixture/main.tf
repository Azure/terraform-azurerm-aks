resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "${random_id.prefix.hex}-rg"
}

resource "azurerm_virtual_network" "test" {
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.52.0.0/16"]
  location            = azurerm_resource_group.main.location
}

resource "azurerm_subnet" "test" {
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.52.0.0/24"]
}

resource "azurerm_user_assigned_identity" "test" {
  name                = "${random_id.prefix.hex}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

module "aks" {
  source                    = "../.."
  prefix                    = "prefix-${random_id.prefix.hex}"
  resource_group_name       = azurerm_resource_group.main.name
  agents_availability_zones = ["1", "2"]
  agents_count              = null
  agents_labels             = {
    "node1" : "label1"
  }
  agents_max_count = 2
  agents_max_pods  = 100
  agents_min_count = 1
  agents_pool_name = "testnodepool"
  agents_tags      = {
    "Agent" : "agentTag"
  }
  agents_type                             = "VirtualMachineScaleSets"
  azure_policy_enabled                    = true
  client_id                               = var.client_id
  client_secret                           = var.client_secret
  disk_encryption_set_id                  = azurerm_disk_encryption_set.des.id
  enable_auto_scaling                     = true
  enable_host_encryption                  = true
  enable_http_application_routing         = true
  enable_ingress_application_gateway      = true
  enable_log_analytics_workspace          = true
  enable_role_based_access_control        = true
  ingress_application_gateway_name        = "${random_id.prefix.hex}-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"
  local_account_disabled                  = true
  net_profile_dns_service_ip              = "10.0.0.10"
  net_profile_docker_bridge_cidr          = "170.10.0.1/16"
  net_profile_service_cidr                = "10.0.0.0/16"
  network_plugin                          = "azure"
  network_policy                          = "azure"
  os_disk_size_gb                         = 60
  private_cluster_enabled                 = true
  rbac_aad_managed                        = true
  sku_tier                                = "Paid"
  vnet_subnet_id                          = azurerm_subnet.test.id

  depends_on = [azurerm_resource_group.main]
}

module "aks_without_monitor" {
  source                           = "../.."
  prefix                           = "prefix2-${random_id.prefix.hex}"
  resource_group_name              = azurerm_resource_group.main.name
  disk_encryption_set_id           = azurerm_disk_encryption_set.des.id
  #checkov:skip=CKV_AZURE_4:The logging is turn off for demo purpose. DO NOT DO THIS IN PRODUCTION ENVIRONMENT!
  enable_log_analytics_workspace   = false
  enable_role_based_access_control = true
  local_account_disabled           = true
  net_profile_pod_cidr             = "10.1.0.0/16"
  private_cluster_enabled          = true
  rbac_aad_managed                 = true

  depends_on = [azurerm_resource_group.main]
}

module "aks_cluster_name" {
  source                               = "../.."
  prefix                               = "prefix"
  resource_group_name                  = azurerm_resource_group.main.name
  # Not necessary, just for demo purpose.
  admin_username                       = "azureuser"
  cluster_log_analytics_workspace_name = "test-cluster"
  cluster_name                         = "test-cluster"
  disk_encryption_set_id               = azurerm_disk_encryption_set.des.id
  enable_log_analytics_workspace       = true
  enable_role_based_access_control     = true
  identity_ids                         = [azurerm_user_assigned_identity.test.id]
  identity_type                        = "UserAssigned"
  local_account_disabled               = true
  net_profile_pod_cidr                 = "10.1.0.0/16"
  private_cluster_enabled              = true
  rbac_aad_managed                     = true

  depends_on = [azurerm_resource_group.main]
}
