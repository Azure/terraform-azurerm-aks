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
  count = var.bring_your_own_vnet ? 1 : 0

  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "test" {
  count = var.bring_your_own_vnet ? 1 : 0

  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test[0].name
}

locals {
  appgw_cidr = !var.use_brown_field_application_gateway && !var.bring_your_own_vnet ? "10.225.0.0/16" : "10.52.1.0/24"
}

resource "azurerm_subnet" "appgw" {
  count = var.use_brown_field_application_gateway && var.bring_your_own_vnet ? 1 : 0

  address_prefixes     = [local.appgw_cidr]
  name                 = "${random_id.prefix.hex}-gw"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test[0].name
}

# Locals block for hardcoded names
locals {
  backend_address_pool_name      = try("${azurerm_virtual_network.test[0].name}-beap", "")
  frontend_ip_configuration_name = try("${azurerm_virtual_network.test[0].name}-feip", "")
  frontend_port_name             = try("${azurerm_virtual_network.test[0].name}-feport", "")
  http_setting_name              = try("${azurerm_virtual_network.test[0].name}-be-htst", "")
  listener_name                  = try("${azurerm_virtual_network.test[0].name}-httplstn", "")
  request_routing_rule_name      = try("${azurerm_virtual_network.test[0].name}-rqrt", "")
}

resource "azurerm_public_ip" "pip" {
  count = var.use_brown_field_application_gateway && var.bring_your_own_vnet ? 1 : 0

  allocation_method   = "Static"
  location            = local.resource_group.location
  name                = "appgw-pip"
  resource_group_name = local.resource_group.name
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  count = var.use_brown_field_application_gateway && var.bring_your_own_vnet ? 1 : 0

  location = local.resource_group.location
  #checkov:skip=CKV_AZURE_120:We don't need the WAF for this simple example
  name                = "ingress"
  resource_group_name = local.resource_group.name

  backend_address_pool {
    name = local.backend_address_pool_name
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.http_setting_name
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip[0].id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgw[0].id
  }
  http_listener {
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    name                           = local.listener_name
    protocol                       = "Http"
  }
  request_routing_rule {
    http_listener_name         = local.listener_name
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule,
      url_path_map,
    ]
  }
}

module "aks" {
  #checkov:skip=CKV_AZURE_141:We enable admin account here so we can provision K8s resources directly in this simple example
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
  agents_type            = "VirtualMachineScaleSets"
  azure_policy_enabled   = true
  enable_auto_scaling    = true
  enable_host_encryption = true
  green_field_application_gateway_for_ingress = var.use_brown_field_application_gateway ? null : {
    name        = "ingress"
    subnet_cidr = local.appgw_cidr
  }
  brown_field_application_gateway_for_ingress = var.use_brown_field_application_gateway ? {
    id        = azurerm_application_gateway.appgw[0].id
    subnet_id = azurerm_subnet.appgw[0].id
  } : null
  create_role_assignments_for_application_gateway = var.create_role_assignments_for_application_gateway
  local_account_disabled                          = false
  log_analytics_workspace_enabled                 = false
  net_profile_dns_service_ip                      = "10.0.0.10"
  net_profile_service_cidr                        = "10.0.0.0/16"
  network_plugin                                  = "azure"
  network_policy                                  = "azure"
  os_disk_size_gb                                 = 60
  private_cluster_enabled                         = false
  rbac_aad                                        = true
  rbac_aad_managed                                = true
  role_based_access_control_enabled               = true
  sku_tier                                        = "Standard"
  vnet_subnet_id                                  = var.bring_your_own_vnet ? azurerm_subnet.test[0].id : null
  depends_on = [
    azurerm_subnet.test,
  ]
}