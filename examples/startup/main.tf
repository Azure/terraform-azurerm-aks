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

module "aks" {
  source = "../.."

  prefix                    = random_id.name.hex
  resource_group_name       = local.resource_group.name
  kubernetes_version        = "1.26" # don't specify the patch version!
  automatic_channel_upgrade = "patch"
  agents_availability_zones = ["1", "2"]
  agents_count              = null
  agents_max_count          = 2
  agents_max_pods           = 100
  agents_min_count          = 1
  agents_pool_name          = "testnodepool"
  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [
        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]
  agents_type          = "VirtualMachineScaleSets"
  azure_policy_enabled = true
  client_id            = var.client_id
  client_secret        = var.client_secret
  confidential_computing = {
    sgx_quote_helper_enabled = true
  }
  disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  enable_auto_scaling    = true
  enable_host_encryption = true
  green_field_application_gateway_for_ingress = {
    name        = "${random_id.prefix.hex}-agw"
    subnet_cidr = "10.52.1.0/24"
  }
  local_account_disabled               = true
  log_analytics_workspace_enabled      = true
  cluster_log_analytics_workspace_name = random_id.name.hex
  maintenance_window = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = [
      {
        start = "2035-01-01T20:00:00Z",
        end   = "2035-01-01T21:00:00Z"
      },
    ]
  }
  maintenance_window_node_os = {
    frequency  = "Daily"
    interval   = 1
    start_time = "07:00"
    utc_offset = "+01:00"
    duration   = 16
  }
  net_profile_dns_service_ip        = "10.0.0.10"
  net_profile_service_cidr          = "10.0.0.0/16"
  network_plugin                    = "azure"
  network_policy                    = "azure"
  node_os_channel_upgrade           = "NodeImage"
  os_disk_size_gb                   = 60
  private_cluster_enabled           = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true
  sku_tier                          = "Standard"
  vnet_subnet_id                    = azurerm_subnet.test.id

  agents_labels = {
    "node1" : "label1"
  }
  agents_tags = {
    "Agent" : "agentTag"
  }
  depends_on = [
    azurerm_subnet.test,
  ]
}
