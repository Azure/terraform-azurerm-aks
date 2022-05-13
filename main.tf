data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.cluster_name != null ? var.cluster_name : var.prefix
  kubernetes_version      = var.kubernetes_version
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  node_resource_group     = var.node_resource_group
  dns_prefix              = coalesce(var.dns_prefix, var.prefix, var.cluster_name)
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_dns_zone_id

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.public_ssh_key != null ? var.public_ssh_key : tls_private_key.main.public_key_openssh
    }
  }

  default_node_pool {
    orchestrator_version   = var.orchestrator_version
    name                   = var.default_node_pool_name
    node_count             = var.node_count
    vm_size                = var.vm_size
    os_sku                 = var.os_sku
    os_disk_type           = var.os_disk_type
    os_disk_size_gb        = var.os_disk_size_gb
    vnet_subnet_id         = var.vnet_subnet_id
    enable_auto_scaling    = var.enable_auto_scaling
    max_count              = var.enable_auto_scaling == true ? var.max_count : null
    min_count              = var.enable_auto_scaling == true ? var.min_count : null
    enable_node_public_ip  = var.enable_node_public_ip
    zones                  = var.zones
    node_labels            = var.node_labels
    node_taints            = var.node_taints
    type                   = var.type
    tags                   = merge(var.tags, var.node_tags)
    max_pods               = var.max_pods
    enable_host_encryption = var.enable_host_encryption
  }

  dynamic "service_principal" {
    for_each = var.service_principal_enabled ? { "loop" = "once" } : {}
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  azure_policy_enabled             = var.azure_policy_enabled
  http_application_routing_enabled = var.http_application_routing_enabled

  dynamic "oms_agent" {
    for_each = try(azurerm_log_analytics_workspace.main[0].id, null) != null ? { "loop" = "once" } : {}

    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway_enabled ? { "loop" = "once" } : {}
    content {
      gateway_id   = var.gateway_id
      gateway_name = var.gateway_name
      subnet_cidr  = var.subnet_cidr
      subnet_id    = var.subnet_id
    }
  }

  azure_active_directory_role_based_access_control {
    managed                = var.rbac_aad_managed
    admin_group_object_ids = var.rbac_aad_managed ? var.rbac_aad_admin_group_object_ids : null
    azure_rbac_enabled     = var.rbac_aad_managed ? var.enable_role_based_access_control : null
    client_app_id          = !var.rbac_aad_managed ? var.rbac_aad_client_app_id : null
    server_app_id          = !var.rbac_aad_managed ? var.rbac_aad_server_app_id : null
    server_app_secret      = !var.rbac_aad_managed ? var.rbac_aad_server_app_secret : null
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.network_plugin != "azure" ? var.pod_cidr : null
    service_cidr       = var.service_cidr
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? var.key_vault_secrets_provider : []

    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  maintenance_window {
    dynamic "allowed" {
      for_each = var.allowed_maintenance_windows

      content {
        day   = allowed.value.day
        hours = allowed.value.hours
      }
    }

    dynamic "not_allowed" {
      for_each = var.not_allowed_maintenance_windows

      content {
        start = not_allowed.value.start
        end   = not_allowed.value.end
      }
    }
  }

  tags = var.tags
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "main" {
  count               = var.log_analytics_workspace_enabled ? 1 : 0
  name                = var.log_analytics_workspace_name == null ? "${coalesce(var.cluster_name, var.prefix)}-workspace" : var.log_analytics_workspace_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.log_analytics_solution_enabled && var.log_analytics_workspace_enabled ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main[0].id
  workspace_name        = azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

# Permissions on provided Azure Container Registry
resource "azurerm_role_assignment" "azure_container_registry" {
  count                            = var.azure_container_registry_enabled ? 1 : 0
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.azure_container_registry_id
  skip_service_principal_aad_check = true
}
