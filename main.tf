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

  default_node_pool {
      orchestrator_version  = lookup(var.default_node_pool,"orchestrator_version",var.kubernetes_version)
      name                  = lookup(var.default_node_pool,"name","nodepool")
      node_count            = var.agents_count == null ? lookup(var.default_node_pool,"node_count",2) : var.agents_count
      vm_size               = lookup(var.default_node_pool,"vm_size","Standard_D2s_v3")
      os_disk_size_gb       = lookup(var.default_node_pool,"os_disk_size_gb",50)
      vnet_subnet_id        = var.vnet_subnet_id == null ? lookup(var.default_node_pool,"vnet_subnet_id",null) : var.vnet_subnet_id
      enable_node_public_ip = lookup(var.default_node_pool,"enable_node_public_ip",null)
      enable_auto_scaling   = lookup(var.default_node_pool,"enable_auto_scaling",null)
      availability_zones    = lookup(var.default_node_pool,"availability_zones",null)
      node_labels           = lookup(var.default_node_pool,"node_labels",null)
      node_taints           = lookup(var.default_node_pool,"node_taints",null)
      type                  = lookup(var.default_node_pool,"type",null)
      tags                  = lookup(var.default_node_pool,"tags",null)
      max_pods              = lookup(var.default_node_pool,"max_pods",null)
      max_count             = lookup(var.default_node_pool,"max_count",null)
      min_count             = lookup(var.default_node_pool,"min_count",null)
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


