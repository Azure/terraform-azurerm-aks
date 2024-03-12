moved {
  from = azurerm_kubernetes_cluster_node_pool.node_pool
  to   = azurerm_kubernetes_cluster_node_pool.node_pool_create_before_destroy
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_before_destroy" {
  for_each = local.node_pools_create_before_destroy

  kubernetes_cluster_id         = azurerm_kubernetes_cluster.main.id
  name                          = "${each.value.name}${substr(md5(uuid()), 0, 4)}"
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  custom_ca_trust_enabled       = each.value.custom_ca_trust_enabled
  enable_auto_scaling           = each.value.enable_auto_scaling
  enable_host_encryption        = each.value.enable_host_encryption
  enable_node_public_ip         = each.value.enable_node_public_ip
  eviction_policy               = each.value.eviction_policy
  fips_enabled                  = each.value.fips_enabled
  gpu_instance                  = each.value.gpu_instance
  host_group_id                 = each.value.host_group_id
  kubelet_disk_type             = each.value.kubelet_disk_type
  max_count                     = each.value.max_count
  max_pods                      = each.value.max_pods
  message_of_the_day            = each.value.message_of_the_day
  min_count                     = each.value.min_count
  mode                          = each.value.mode
  node_count                    = each.value.node_count
  node_labels                   = each.value.node_labels
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  node_taints                   = each.value.node_taints
  orchestrator_version          = each.value.orchestrator_version
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  pod_subnet_id                 = each.value.pod_subnet_id
  priority                      = each.value.priority
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode               = each.value.scale_down_mode
  snapshot_id                   = each.value.snapshot_id
  spot_max_price                = each.value.spot_max_price
  tags = merge(each.value.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name             = "node_pool_create_before_destroy"
    avm_git_commit           = "749123dd248895875cff37e4d921fa8013f4e05d"
    avm_git_file             = "extra_node_pool.tf"
    avm_git_last_modified_at = "2024-03-04 03:19:50"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "ff0e2d82-71a0-49ca-bbba-0b77c2530dca"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
  ultra_ssd_enabled = each.value.ultra_ssd_enabled
  vnet_subnet_id    = each.value.vnet_subnet_id
  workload_runtime  = each.value.workload_runtime
  zones             = each.value.zones

  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config == null ? [] : ["kubelet_config"]

    content {
      allowed_unsafe_sysctls    = each.value.kubelet_config.allowed_unsafe_sysctls
      container_log_max_line    = each.value.kubelet_config.container_log_max_files
      container_log_max_size_mb = each.value.kubelet_config.container_log_max_size_mb
      cpu_cfs_quota_enabled     = each.value.kubelet_config.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = each.value.kubelet_config.cpu_cfs_quota_period
      cpu_manager_policy        = each.value.kubelet_config.cpu_manager_policy
      image_gc_high_threshold   = each.value.kubelet_config.image_gc_high_threshold
      image_gc_low_threshold    = each.value.kubelet_config.image_gc_low_threshold
      pod_max_pid               = each.value.kubelet_config.pod_max_pid
      topology_manager_policy   = each.value.kubelet_config.topology_manager_policy
    }
  }
  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config == null ? [] : ["linux_os_config"]

    content {
      swap_file_size_mb             = each.value.linux_os_config.swap_file_size_mb
      transparent_huge_page_defrag  = each.value.linux_os_config.transparent_huge_page_defrag
      transparent_huge_page_enabled = each.value.linux_os_config.transparent_huge_page_enabled

      dynamic "sysctl_config" {
        for_each = each.value.linux_os_config.sysctl_config == null ? [] : ["sysctl_config"]

        content {
          fs_aio_max_nr                      = each.value.linux_os_config.sysctl_config.fs_aio_max_nr
          fs_file_max                        = each.value.linux_os_config.sysctl_config.fs_file_max
          fs_inotify_max_user_watches        = each.value.linux_os_config.sysctl_config.fs_inotify_max_user_watches
          fs_nr_open                         = each.value.linux_os_config.sysctl_config.fs_nr_open
          kernel_threads_max                 = each.value.linux_os_config.sysctl_config.kernel_threads_max
          net_core_netdev_max_backlog        = each.value.linux_os_config.sysctl_config.net_core_netdev_max_backlog
          net_core_optmem_max                = each.value.linux_os_config.sysctl_config.net_core_optmem_max
          net_core_rmem_default              = each.value.linux_os_config.sysctl_config.net_core_rmem_default
          net_core_rmem_max                  = each.value.linux_os_config.sysctl_config.net_core_rmem_max
          net_core_somaxconn                 = each.value.linux_os_config.sysctl_config.net_core_somaxconn
          net_core_wmem_default              = each.value.linux_os_config.sysctl_config.net_core_wmem_default
          net_core_wmem_max                  = each.value.linux_os_config.sysctl_config.net_core_wmem_max
          net_ipv4_ip_local_port_range_max   = each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max
          net_ipv4_ip_local_port_range_min   = each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min
          net_ipv4_neigh_default_gc_thresh1  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1
          net_ipv4_neigh_default_gc_thresh2  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2
          net_ipv4_neigh_default_gc_thresh3  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3
          net_ipv4_tcp_fin_timeout           = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout
          net_ipv4_tcp_keepalive_intvl       = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes      = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time        = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time
          net_ipv4_tcp_max_syn_backlog       = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog
          net_ipv4_tcp_max_tw_buckets        = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets
          net_ipv4_tcp_tw_reuse              = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse
          net_netfilter_nf_conntrack_buckets = each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets
          net_netfilter_nf_conntrack_max     = each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max
          vm_max_map_count                   = each.value.linux_os_config.sysctl_config.vm_max_map_count
          vm_swappiness                      = each.value.linux_os_config.sysctl_config.vm_swappiness
          vm_vfs_cache_pressure              = each.value.linux_os_config.sysctl_config.vm_vfs_cache_pressure
        }
      }
    }
  }
  dynamic "node_network_profile" {
    for_each = each.value.node_network_profile == null ? [] : ["node_network_profile"]

    content {
      node_public_ip_tags = each.value.node_network_profile.node_public_ip_tags
    }
  }
  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings == null ? [] : ["upgrade_settings"]

    content {
      max_surge = each.value.upgrade_settings.max_surge
    }
  }
  dynamic "windows_profile" {
    for_each = each.value.windows_profile == null ? [] : ["windows_profile"]

    content {
      outbound_nat_enabled = each.value.windows_profile.outbound_nat_enabled
    }
  }

  depends_on = [azapi_update_resource.aks_cluster_post_create]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name
    ]
    replace_triggered_by = [
      null_resource.pool_name_keeper[each.key],
    ]

    precondition {
      condition     = can(regex("[a-z0-9]{1,8}", each.value.name))
      error_message = "A Node Pools name must consist of alphanumeric characters and have a maximum lenght of 8 characters (4 random chars added)"
    }
    precondition {
      condition     = var.network_plugin_mode != "overlay" || !can(regex("^Standard_DC[0-9]+s?_v2$", each.value.vm_size))
      error_message = "With with Azure CNI Overlay you can't use DCsv2-series virtual machines in node pools. "
    }
    precondition {
      condition     = var.agents_type == "VirtualMachineScaleSets"
      error_message = "Multiple Node Pools are only supported when the Kubernetes Cluster is using Virtual Machine Scale Sets."
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_after_destroy" {
  for_each = local.node_pools_create_after_destroy

  kubernetes_cluster_id         = azurerm_kubernetes_cluster.main.id
  name                          = each.value.name
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  custom_ca_trust_enabled       = each.value.custom_ca_trust_enabled
  enable_auto_scaling           = each.value.enable_auto_scaling
  enable_host_encryption        = each.value.enable_host_encryption
  enable_node_public_ip         = each.value.enable_node_public_ip
  eviction_policy               = each.value.eviction_policy
  fips_enabled                  = each.value.fips_enabled
  host_group_id                 = each.value.host_group_id
  kubelet_disk_type             = each.value.kubelet_disk_type
  max_count                     = each.value.max_count
  max_pods                      = each.value.max_pods
  message_of_the_day            = each.value.message_of_the_day
  min_count                     = each.value.min_count
  mode                          = each.value.mode
  node_count                    = each.value.node_count
  node_labels                   = each.value.node_labels
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  node_taints                   = each.value.node_taints
  orchestrator_version          = each.value.orchestrator_version
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  pod_subnet_id                 = each.value.pod_subnet_id
  priority                      = each.value.priority
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode               = each.value.scale_down_mode
  snapshot_id                   = each.value.snapshot_id
  spot_max_price                = each.value.spot_max_price
  tags = merge(each.value.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name             = "node_pool_create_after_destroy"
    avm_git_commit           = "6167ef652d1bc9d1cd9557d3dc101f8681302218"
    avm_git_file             = "extra_node_pool.tf"
    avm_git_last_modified_at = "2024-01-11 08:26:20"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-aks"
    avm_yor_trace            = "8d2ee439-9079-42ba-92ea-134db0cf097a"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
  ultra_ssd_enabled = each.value.ultra_ssd_enabled
  vnet_subnet_id    = each.value.vnet_subnet_id
  workload_runtime  = each.value.workload_runtime
  zones             = each.value.zones

  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config == null ? [] : ["kubelet_config"]

    content {
      allowed_unsafe_sysctls    = each.value.kubelet_config.allowed_unsafe_sysctls
      container_log_max_line    = each.value.kubelet_config.container_log_max_files
      container_log_max_size_mb = each.value.kubelet_config.container_log_max_size_mb
      cpu_cfs_quota_enabled     = each.value.kubelet_config.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = each.value.kubelet_config.cpu_cfs_quota_period
      cpu_manager_policy        = each.value.kubelet_config.cpu_manager_policy
      image_gc_high_threshold   = each.value.kubelet_config.image_gc_high_threshold
      image_gc_low_threshold    = each.value.kubelet_config.image_gc_low_threshold
      pod_max_pid               = each.value.kubelet_config.pod_max_pid
      topology_manager_policy   = each.value.kubelet_config.topology_manager_policy
    }
  }
  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config == null ? [] : ["linux_os_config"]

    content {
      swap_file_size_mb             = each.value.linux_os_config.swap_file_size_mb
      transparent_huge_page_defrag  = each.value.linux_os_config.transparent_huge_page_defrag
      transparent_huge_page_enabled = each.value.linux_os_config.transparent_huge_page_enabled

      dynamic "sysctl_config" {
        for_each = each.value.linux_os_config.sysctl_config == null ? [] : ["sysctl_config"]

        content {
          fs_aio_max_nr                      = each.value.linux_os_config.sysctl_config.fs_aio_max_nr
          fs_file_max                        = each.value.linux_os_config.sysctl_config.fs_file_max
          fs_inotify_max_user_watches        = each.value.linux_os_config.sysctl_config.fs_inotify_max_user_watches
          fs_nr_open                         = each.value.linux_os_config.sysctl_config.fs_nr_open
          kernel_threads_max                 = each.value.linux_os_config.sysctl_config.kernel_threads_max
          net_core_netdev_max_backlog        = each.value.linux_os_config.sysctl_config.net_core_netdev_max_backlog
          net_core_optmem_max                = each.value.linux_os_config.sysctl_config.net_core_optmem_max
          net_core_rmem_default              = each.value.linux_os_config.sysctl_config.net_core_rmem_default
          net_core_rmem_max                  = each.value.linux_os_config.sysctl_config.net_core_rmem_max
          net_core_somaxconn                 = each.value.linux_os_config.sysctl_config.net_core_somaxconn
          net_core_wmem_default              = each.value.linux_os_config.sysctl_config.net_core_wmem_default
          net_core_wmem_max                  = each.value.linux_os_config.sysctl_config.net_core_wmem_max
          net_ipv4_ip_local_port_range_max   = each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max
          net_ipv4_ip_local_port_range_min   = each.value.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min
          net_ipv4_neigh_default_gc_thresh1  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1
          net_ipv4_neigh_default_gc_thresh2  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2
          net_ipv4_neigh_default_gc_thresh3  = each.value.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3
          net_ipv4_tcp_fin_timeout           = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout
          net_ipv4_tcp_keepalive_intvl       = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes      = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time        = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time
          net_ipv4_tcp_max_syn_backlog       = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog
          net_ipv4_tcp_max_tw_buckets        = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets
          net_ipv4_tcp_tw_reuse              = each.value.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse
          net_netfilter_nf_conntrack_buckets = each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets
          net_netfilter_nf_conntrack_max     = each.value.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max
          vm_max_map_count                   = each.value.linux_os_config.sysctl_config.vm_max_map_count
          vm_swappiness                      = each.value.linux_os_config.sysctl_config.vm_swappiness
          vm_vfs_cache_pressure              = each.value.linux_os_config.sysctl_config.vm_vfs_cache_pressure
        }
      }
    }
  }
  dynamic "node_network_profile" {
    for_each = each.value.node_network_profile == null ? [] : ["node_network_profile"]

    content {
      node_public_ip_tags = each.value.node_network_profile.node_public_ip_tags
    }
  }
  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings == null ? [] : ["upgrade_settings"]

    content {
      max_surge = each.value.upgrade_settings.max_surge
    }
  }
  dynamic "windows_profile" {
    for_each = each.value.windows_profile == null ? [] : ["windows_profile"]

    content {
      outbound_nat_enabled = each.value.windows_profile.outbound_nat_enabled
    }
  }

  depends_on = [azapi_update_resource.aks_cluster_post_create]

  lifecycle {
    precondition {
      condition     = can(regex("[a-z0-9]{1,8}", each.value.name))
      error_message = "A Node Pools name must consist of alphanumeric characters and have a maximum lenght of 8 characters (4 random chars added)"
    }
    precondition {
      condition     = var.network_plugin_mode != "overlay" || !can(regex("^Standard_DC[0-9]+s?_v2$", each.value.vm_size))
      error_message = "With with Azure CNI Overlay you can't use DCsv2-series virtual machines in node pools. "
    }
    precondition {
      condition     = var.agents_type == "VirtualMachineScaleSets"
      error_message = "Multiple Node Pools are only supported when the Kubernetes Cluster is using Virtual Machine Scale Sets."
    }
  }
}

resource "null_resource" "pool_name_keeper" {
  for_each = var.node_pools

  triggers = {
    pool_name = each.value.name
  }
}
