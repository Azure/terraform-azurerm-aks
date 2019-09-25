resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prefix
  kubernetes_version  = var.kubernetes_version

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.admin_public_ssh_key, "\n", "")
    }
  }

  agent_pool_profile {
    name                = lookup(var.agent_pool_profile, "name", null)
    count               = lookup(var.agent_pool_profile, "count", null)
    vm_size             = lookup(var.agent_pool_profile, "vm_size", null)
    availability_zones  = lookup(var.agent_pool_profile, "availability_zones", null)
    enable_auto_scaling = lookup(var.agent_pool_profile, "enable_auto_scaling", null)
    min_count           = lookup(var.agent_pool_profile, "min_count", null)
    max_count           = lookup(var.agent_pool_profile, "max_count", null)
    max_pods            = lookup(var.agent_pool_profile, "max_pods", null)
    os_disk_size_gb     = lookup(var.agent_pool_profile, "os_disk_size_gb", null)
    os_type             = lookup(var.agent_pool_profile, "os_type", null)
    type                = lookup(var.agent_pool_profile, "type", null)
    vnet_subnet_id      = lookup(var.agent_pool_profile, "vnet_subnet_id", null)
    node_taints         = lookup(var.agent_pool_profile, "node_taints", null)
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    pod_cidr           = var.network_profile.pod_cidr
    service_cidr       = var.network_profile.service_cidr
  }

  tags = var.tags
}
