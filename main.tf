data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

moved {
  from = module.ssh-key.tls_private_key.ssh
  to   = tls_private_key.ssh[0]
}

resource "tls_private_key" "ssh" {
  count = var.admin_username == null ? 0 : 1

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "main" {
  name                                = var.cluster_name == null ? "${var.prefix}-aks" : var.cluster_name
  location                            = coalesce(var.location, data.azurerm_resource_group.main.location)
  resource_group_name                 = data.azurerm_resource_group.main.name
  dns_prefix                          = var.prefix
  api_server_authorized_ip_ranges     = var.api_server_authorized_ip_ranges
  azure_policy_enabled                = var.azure_policy_enabled
  disk_encryption_set_id              = var.disk_encryption_set_id
  http_application_routing_enabled    = var.http_application_routing_enabled
  kubernetes_version                  = var.kubernetes_version
  local_account_disabled              = var.local_account_disabled
  node_resource_group                 = var.node_resource_group
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  open_service_mesh_enabled           = var.open_service_mesh_enabled
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  role_based_access_control_enabled   = var.role_based_access_control_enabled
  sku_tier                            = var.sku_tier
  tags                                = var.tags

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      max_pods                     = var.agents_max_pods
      node_labels                  = var.agents_labels
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      vnet_subnet_id               = var.vnet_subnet_id
      max_count                    = null
      min_count                    = null
      node_count                   = var.agents_count
      zones                        = var.agents_availability_zones
    }
  }
  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      max_pods                     = var.agents_max_pods
      node_labels                  = var.agents_labels
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      type                         = var.agents_type
      tags                         = merge(var.tags, var.agents_tags)
      vnet_subnet_id               = var.vnet_subnet_id
      max_count                    = var.agents_max_count
      min_count                    = var.agents_min_count
      zones                        = var.agents_availability_zones
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.role_based_access_control_enabled && var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed                = true
      tenant_id              = var.rbac_aad_tenant_id
      admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      azure_rbac_enabled     = var.rbac_aad_azure_rbac_enabled
    }
  }
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.role_based_access_control_enabled && !var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed           = false
      tenant_id         = var.rbac_aad_tenant_id
      client_app_id     = var.rbac_aad_client_app_id
      server_app_id     = var.rbac_aad_server_app_id
      server_app_secret = var.rbac_aad_server_app_secret
    }
  }

  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway_enabled ? ["ingress_application_gateway"] : []
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

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.net_profile_dns_service_ip
    docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    outbound_type      = var.net_profile_outbound_type
    pod_cidr           = var.net_profile_pod_cidr
    service_cidr       = var.net_profile_service_cidr
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_enabled ? ["oms_agent"] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace == null ? azurerm_log_analytics_workspace.main[0].id : var.log_analytics_workspace.id
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  lifecycle {
    precondition {
      condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type != "")
      error_message = "Either `client_id` and `client_secret` or `identity_type` must be set."
    }
    precondition {
      # Why don't use var.identity_ids != null && length(var.identity_ids)>0 ? Because bool expression in Terraform is not short circuit so even var.identity_ids is null Terraform will still invoke length function with null and cause error. https://github.com/hashicorp/terraform/issues/24128
      condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type == "SystemAssigned") || (var.identity_ids == null ? false : length(var.identity_ids) > 0)
      error_message = "If use identity and `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well."
    }
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  count = var.log_analytics_workspace_enabled && var.log_analytics_workspace == null ? 1 : 0

  name                = var.cluster_log_analytics_workspace_name == null ? "${var.prefix}-workspace" : var.cluster_log_analytics_workspace_name
  location            = coalesce(var.location, data.azurerm_resource_group.main.location)
  resource_group_name = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.log_analytics_workspace_enabled && var.log_analytics_solution_id == null ? 1 : 0
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
