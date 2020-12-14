data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.prefix
  kubernetes_version      = var.kubernetes_version
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  dns_prefix              = var.prefix
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled

  linux_profile {
    admin_username = var.admin_username

  ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
    }
  }

<<<<<<< HEAD
 default_node_pool {
      orchestrator_version  = var.agentpool_kubernetes_version == null ? var.kubernetes_version : var.agentpool_kubernetes_version
      name                  = var.agentpool_name
      node_count            = var.agentpool_node_count
      vm_size               = var.agentpool_vm_size
      os_disk_size_gb       = var.agentpool.os_disk_size_gb
      vnet_subnet_id        = var.agentpool_vnet_subnet_id
      enable_node_public_ip = var.agentpool_enable_node_public_ip
      enable_auto_scaling   = var.agentpool_enable_auto_scaling
      availability_zones    = var.agentpool_availability_zones
      node_labels           = var.agentpool_node_labels
      node_taints           = var.agentpool_node_taints
      type                  = var.agentpool_type
      tags                  = merge(var.tags, var.agentpool_tags)
      max_pods              = var.agentpool_max_pods
      max_count             = var.agentpool_max_count
      min_count             = var.agentpool_min_count
=======
  default_node_pool {
    orchestrator_version = var.orchestrator_version
    name                 = "nodepool"
    node_count           = var.agents_count
    vm_size              = var.agents_size
    os_disk_size_gb      = var.os_disk_size_gb
    vnet_subnet_id       = var.vnet_subnet_id
    enable_auto_scaling  = var.enable_auto_scaling
    max_count            = var.enable_auto_scaling ? var.agents_max_count : null
    min_count            = var.enable_auto_scaling ? var.agents_min_count : null
>>>>>>> tmp/master
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
      type = "SystemAssigned"
    }
  }

  dynamic "network_profile" {
    for_each = length(keys(var.network_profile)) == 0 ? [] : [var.network_profile]
    content {
      network_plugin     = lookup(network_profile.value,"network_plugin","kubenet")
      dns_service_ip     = lookup(network_profile.value,"dns_service_ip",null)
      docker_bridge_cidr = lookup(network_profile.value,"docker_bridge_cidr",null)
      service_cidr       = lookup(network_profile.value,"service_cidr",null)
    }
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    dynamic "kube_dashboard" {
      for_each = var.enable_kube_dashboard != null ? ["kube_dashboard"] : []
      content {
        enabled = var.enable_kube_dashboard
      }
    }

    dynamic "azure_policy" {
      for_each = var.enable_azure_policy ? ["azure_policy"] : []
      content {
        enabled = true
      }
    }

    dynamic "oms_agent" {
      for_each = var.enable_log_analytics_workspace ? ["log_analytics"] : []
      content {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
      }
    }
  }

  role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && ! var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.rbac_aad_client_app_id
        server_app_id     = var.rbac_aad_server_app_id
        server_app_secret = var.rbac_aad_server_app_secret
      }
    }
  }

  network_profile {
    network_plugin = var.network_plugin
  }

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  name                = "${var.prefix}-workspace"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
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


