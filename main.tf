data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  kubernetes_version  = var.kubernetes_version
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = var.prefix
  sku_tier            = var.sku_tier

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
    }
  }

  dynamic "default_node_pool" {
    for_each = var.default_node_pool != [] ? var.default_node_pool : [{ name = "nodepool", node_count = var.agents_count, vmnet_subnet_id = var.vmnet_subnet_id}]

    content {
      orchestrator_version  = default_node_pool.value.orchestrator_version == null ? var.kubernetes_version : default_node_pool.value.orchestrator_version 
      name                  = default_node_pool.value.name
      node_count            = default_node_pool.value.node_count == null ? var.agents_count : default_node_pool.value.node_count
      vm_size               = default_node_pool.value.vm_size
      os_disk_size_gb       = default_node_pool.value.os_disk_size_gb
      vnet_subnet_id        = default_node_pool.value.vnet_subnet_id == null ? var.vnet_subnet_id : default_node_pool.value.vnet_subnet_id 
      enable_node_public_ip = default_node_pool.value.enable_node_public_ip
      enable_auto_scaling   = default_node_pool.value.enable_auto_scaling
      availability_zones    = default_node_pool.value.availability_zones
      node_labels           = default_node_pool.value.node_labels
      node_taints           = default_node_pool.value.node_taints
      type                  = default_node_pool.value.type
      tags                  = default_node_pool.value.tags
      max_pods              = default_node_pool.value.max_pods
      max_count             = default_node_pool.value.max_count
      min_count             = default_node_pool.value.min_count
    }
  }

  dynamic service_principal {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic identity {
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

    dynamic azure_policy {
      for_each = var.enable_azure_policy ? ["azure_policy"] : []
      content {
        enabled = true
      }
    }

    dynamic oms_agent {
      for_each = var.enable_log_analytics_workspace ? ["log_analytics"] : []
      content {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
      }
    }
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
}


