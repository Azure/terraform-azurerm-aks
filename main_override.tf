resource "azurerm_kubernetes_cluster" "main" {
  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]

    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      fips_enabled                 = var.default_node_pool_fips_enabled
      max_count                    = null
      max_pods                     = var.agents_max_pods
      min_count                    = null
      node_count                   = var.agents_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      proximity_placement_group_id = var.agents_proximity_placement_group_id
      scale_down_mode              = var.scale_down_mode
      snapshot_id                  = var.snapshot_id
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones

      dynamic "kubelet_config" {
        for_each = var.agents_pool_kubelet_configs

        content {
          allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
          container_log_max_line    = kubelet_config.value.container_log_max_line
          container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
          cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
          cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
          cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
          image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
          image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
          pod_max_pid               = kubelet_config.value.pod_max_pid
          topology_manager_policy   = kubelet_config.value.topology_manager_policy
        }
      }
      dynamic "linux_os_config" {
        for_each = var.agents_pool_linux_os_configs

        content {
          swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
          transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
          transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled

          dynamic "sysctl_config" {
            for_each = linux_os_config.value.sysctl_configs == null ? [] : linux_os_config.value.sysctl_configs

            content {
              fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
              fs_file_max                        = sysctl_config.value.fs_file_max
              fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
              fs_nr_open                         = sysctl_config.value.fs_nr_open
              kernel_threads_max                 = sysctl_config.value.kernel_threads_max
              net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
              net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
              net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
              net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
              net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
              net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
              net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
              net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
              net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
              net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
              net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
              net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
              net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
              net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
              net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
              net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
              net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
              net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
              net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
              net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
              net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
              vm_max_map_count                   = sysctl_config.value.vm_max_map_count
              vm_swappiness                      = sysctl_config.value.vm_swappiness
              vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
            }
          }
        }
      }
      dynamic "upgrade_settings" {
        for_each = var.agents_pool_max_surge == null ? [] : ["upgrade_settings"]

        content {
          max_surge                     = var.agents_pool_max_surge
          drain_timeout_in_minutes      = var.agents_pool_drain_timeout_in_minutes
          node_soak_duration_in_minutes = var.agents_pool_node_soak_duration_in_minutes
        }
      }
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
      fips_enabled                 = var.default_node_pool_fips_enabled
      max_count                    = var.agents_max_count
      max_pods                     = var.agents_max_pods
      min_count                    = var.agents_min_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      proximity_placement_group_id = var.agents_proximity_placement_group_id
      scale_down_mode              = var.scale_down_mode
      snapshot_id                  = var.snapshot_id
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones

      dynamic "kubelet_config" {
        for_each = var.agents_pool_kubelet_configs

        content {
          allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
          container_log_max_line    = kubelet_config.value.container_log_max_line
          container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
          cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
          cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
          cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
          image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
          image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
          pod_max_pid               = kubelet_config.value.pod_max_pid
          topology_manager_policy   = kubelet_config.value.topology_manager_policy
        }
      }
      dynamic "linux_os_config" {
        for_each = var.agents_pool_linux_os_configs

        content {
          swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
          transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
          transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled

          dynamic "sysctl_config" {
            for_each = linux_os_config.value.sysctl_configs == null ? [] : linux_os_config.value.sysctl_configs

            content {
              fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
              fs_file_max                        = sysctl_config.value.fs_file_max
              fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
              fs_nr_open                         = sysctl_config.value.fs_nr_open
              kernel_threads_max                 = sysctl_config.value.kernel_threads_max
              net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
              net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
              net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
              net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
              net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
              net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
              net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
              net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
              net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
              net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
              net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
              net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
              net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
              net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
              net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
              net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
              net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
              net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
              net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
              net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
              net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
              vm_max_map_count                   = sysctl_config.value.vm_max_map_count
              vm_swappiness                      = sysctl_config.value.vm_swappiness
              vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
            }
          }
        }
      }
      dynamic "upgrade_settings" {
        for_each = var.agents_pool_max_surge == null ? [] : ["upgrade_settings"]

        content {
          max_surge                     = var.agents_pool_max_surge
          drain_timeout_in_minutes      = var.agents_pool_drain_timeout_in_minutes
          node_soak_duration_in_minutes = var.agents_pool_node_soak_duration_in_minutes
        }
      }
    }
  }
  network_profile {
    network_plugin      = var.network_plugin
    dns_service_ip      = var.net_profile_dns_service_ip
    ebpf_data_plane     = var.ebpf_data_plane
    load_balancer_sku   = var.load_balancer_sku
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    outbound_type       = var.net_profile_outbound_type
    pod_cidr            = var.net_profile_pod_cidr
    service_cidr        = var.net_profile_service_cidr

    dynamic "load_balancer_profile" {
      for_each = var.load_balancer_profile_enabled && var.load_balancer_sku == "standard" ? [
        "load_balancer_profile"
      ] : []

      content {
        idle_timeout_in_minutes     = var.load_balancer_profile_idle_timeout_in_minutes
        managed_outbound_ip_count   = var.load_balancer_profile_managed_outbound_ip_count
        managed_outbound_ipv6_count = var.load_balancer_profile_managed_outbound_ipv6_count
        outbound_ip_address_ids     = var.load_balancer_profile_outbound_ip_address_ids
        outbound_ip_prefix_ids      = var.load_balancer_profile_outbound_ip_prefix_ids
        outbound_ports_allocated    = var.load_balancer_profile_outbound_ports_allocated
      }
    }
  }

  lifecycle {
    ignore_changes = [
      http_application_routing_enabled,
      http_proxy_config[0].no_proxy,
      kubernetes_version,
      public_network_access_enabled,
      # we might have a random suffix in cluster's name so we have to ignore it here, but we've traced user supplied cluster name by `null_resource.kubernetes_cluster_name_keeper` so when the name is changed we'll recreate this resource.
      name,
    ]
  }
}