data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

moved {
  from = module.ssh-key.tls_private_key.ssh
  to   = tls_private_key.ssh
}

resource "tls_private_key" "ssh" {
  count     = var.admin_username == null ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "main" {
  name                                = var.cluster_name == null ? "${var.prefix}-aks" : var.cluster_name
  kubernetes_version                  = var.kubernetes_version
  location                            = coalesce(var.location, data.azurerm_resource_group.main.location)
  resource_group_name                 = data.azurerm_resource_group.main.name
  node_resource_group                 = var.node_resource_group
  disk_encryption_set_id              = var.disk_encryption_set_id
  dns_prefix                          = var.prefix
  sku_tier                            = var.sku_tier
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  local_account_disabled              = var.local_account_disabled
  api_server_authorized_ip_ranges     = var.api_server_authorized_ip_ranges

  dynamic "linux_profile" {
    for_each = var.admin_username == null ? [] : ["linux_profile"]
    content {
      admin_username = var.admin_username

      ssh_key {
        # remove any new lines using the replace interpolation function
        key_data = replace(coalesce(var.public_ssh_key, tls_private_key.ssh[0].public_key_openssh), "\n", "")
      }
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      orchestrator_version         = var.orchestrator_version
      name                         = var.agents_pool_name
      node_count                   = var.agents_count
      vm_size                      = var.agents_size
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      vnet_subnet_id               = var.vnet_subnet_id
      enable_auto_scaling          = var.enable_auto_scaling
      max_count                    = null
      min_count                    = null
      enable_node_public_ip        = var.enable_node_public_ip
      zones                        = var.agents_availability_zones
      node_labels                  = var.agents_labels
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      max_pods                     = var.agents_max_pods
      enable_host_encryption       = var.enable_host_encryption
      only_critical_addons_enabled = var.only_critical_addons_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      orchestrator_version         = var.orchestrator_version
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      vnet_subnet_id               = var.vnet_subnet_id
      enable_auto_scaling          = var.enable_auto_scaling
      max_count                    = var.agents_max_count
      min_count                    = var.agents_min_count
      enable_node_public_ip        = var.enable_node_public_ip
      zones                        = var.agents_availability_zones
      node_labels                  = var.agents_labels
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      max_pods                     = var.agents_max_pods
      enable_host_encryption       = var.enable_host_encryption
      only_critical_addons_enabled = var.only_critical_addons_enabled
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  http_application_routing_enabled = var.enable_http_application_routing

  azure_policy_enabled = var.azure_policy_enabled

  dynamic "oms_agent" {
    for_each = var.enable_log_analytics_workspace ? ["oms_agent"] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace == null ? azurerm_log_analytics_workspace.main[0].id : var.log_analytics_workspace.id
    }
  }

  open_service_mesh_enabled = var.enable_open_service_mesh

  dynamic "ingress_application_gateway" {
    for_each = var.enable_ingress_application_gateway ? ["ingress_application_gateway"] : []
    content {
      gateway_id   = var.ingress_application_gateway_id
      gateway_name = var.ingress_application_gateway_name
      subnet_cidr  = var.ingress_application_gateway_subnet_cidr
      subnet_id    = var.ingress_application_gateway_subnet_id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? ["key_vault_secrets_provider"] : []
    content {
      secret_rotation_enabled  = var.secret_rotation_enabled
      secret_rotation_interval = var.secret_rotation_interval
    }
  }

  role_based_access_control_enabled = var.enable_role_based_access_control

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed                = true
      admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      azure_rbac_enabled     = var.rbac_aad_azure_rbac_enabled
      tenant_id              = var.rbac_aad_tenant_id
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_role_based_access_control && !var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed           = false
      client_app_id     = var.rbac_aad_client_app_id
      server_app_id     = var.rbac_aad_server_app_id
      server_app_secret = var.rbac_aad_server_app_secret
      tenant_id         = var.rbac_aad_tenant_id
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.net_profile_dns_service_ip
    docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    outbound_type      = var.net_profile_outbound_type
    pod_cidr           = var.net_profile_pod_cidr
    service_cidr       = var.net_profile_service_cidr
  }

  oidc_issuer_enabled = var.oidc_issuer_enabled

  tags = var.tags
}


resource "azurerm_log_analytics_workspace" "main" {
  count               = var.enable_log_analytics_workspace && var.log_analytics_workspace == null ? 1 : 0
  name                = var.cluster_log_analytics_workspace_name == null ? "${var.prefix}-workspace" : var.cluster_log_analytics_workspace_name
  location            = coalesce(var.location, data.azurerm_resource_group.main.location)
  resource_group_name = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.enable_log_analytics_workspace && var.log_analytics_solution_id == null ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = coalesce(var.location, data.azurerm_resource_group.main.location)
  resource_group_name   = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  workspace_resource_id = var.log_analytics_workspace != null ? var.log_analytics_workspace.id : azurerm_log_analytics_workspace.main[0].id
  workspace_name        = var.log_analytics_workspace != null ? var.log_analytics_workspace.name : azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}
