resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prefix
  kubernetes_version  = var.kubernetes_version

  role_based_access_control {
    enabled           = var.rbac_enabled
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.admin_public_ssh_key, "\n", "")
    }
  }

  default_node_pool {
    name                  = lookup(var.default_node_pool, "name", null)
    vm_size               = lookup(var.default_node_pool, "vm_size", null)
    availability_zones    = var.default_node_pool_availability_zones
    enable_auto_scaling   = lookup(var.default_node_pool, "enable_auto_scaling", null)
    enable_node_public_ip = lookup(var.default_node_pool, "enable_node_public_ip", null)
    max_pods              = lookup(var.default_node_pool, "max_pods", null)
    node_taints           = var.default_node_pool_node_taints
    os_disk_size_gb       = lookup(var.default_node_pool, "os_disk_size_gb", null)
    type                  = lookup(var.default_node_pool, "type", null)
    vnet_subnet_id        = lookup(var.default_node_pool, "vnet_subnet_id", null)
    min_count             = lookup(var.default_node_pool, "min_count", null)
    max_count             = lookup(var.default_node_pool, "max_count", null)
    node_count            = lookup(var.default_node_pool, "node_count", null)
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

  # lifecycle {
  #   ignore_changes = var.aks_ignore_changes
  # }

  tags = var.tags
}
