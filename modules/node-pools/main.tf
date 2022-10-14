resource "azurerm_kubernetes_cluster_node_pool" "workers" {
  for_each = var.additional_node_pools

  name                  = each.value["name"]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.main.id
  vm_size               = each.value["vm_size"]

  enable_auto_scaling          = lookup(each.value, "enable_auto_scaling", false)
  enable_host_encryption       = lookup(each.value, "enable_host_encryption", false)
  enable_node_public_ip        = lookup(each.value, "enable_node_public_ip", false)
  eviction_policy              = lookup(each.value, "priority", "Regular") == "Spot" ? lookup(each.value, "eviction_policy", "Delete") : null
  fips_enabled                 = lookup(each.value, "fips_enabled", false)
  kubelet_disk_type            = lookup(each.value, "kubelet_disk_type", null)
  max_pods                     = lookup(each.value, "max_pods", null)
  mode                         = lookup(each.value, "mode", "User")
  node_labels                  = lookup(each.value, "node_labels", null)
  node_public_ip_prefix_id     = lookup(each.value, "enable_node_public_ip", false) == true ? lookup(each.value, "node_public_ip_prefix_id", null) : null
  node_taints                  = lookup(each.value, "node_taints", [])
  orchestrator_version         = lookup(each.value, "orchestrator_version", null)
  os_disk_size_gb              = lookup(each.value, "os_disk_size_gb", null)
  os_disk_type                 = lookup(each.value, "os_disk_type", "Managed")
  pod_subnet_id                = lookup(each.value, "pod_subnet_id", null)
  os_sku                       = lookup(each.value, "os_sku", "Ubuntu")
  os_type                      = lookup(each.value, "os_type", "Linux")
  priority                     = lookup(each.value, "priority", "Regular")
  proximity_placement_group_id = lookup(each.value, "proximity_placement_group_id", null)
  spot_max_price               = lookup(each.value, "spot_max_price", -1)
  tags                         = merge(var.tags, lookup(each.value, "tags", {}))
  scale_down_mode              = lookup(each.value, "priority", "Regular") == "Regular" ? lookup(each.value, "scale_down_mode", "Delete") : "Delete"
  ultra_ssd_enabled            = lookup(each.value, "ultra_ssd_enabled", false)
  vnet_subnet_id               = var.vnet_subnet_id
  workload_runtime             = lookup(each.value, "workload_runtime", "OCIContainer")
  zones                        = lookup(each.value, "zones", [])
  max_count                    = lookup(each.value, "enable_auto_scaling", false) == true ? lookup(each.value, "max_count", null) : null
  min_count                    = lookup(each.value, "enable_auto_scaling", false) == true ? lookup(each.value, "min_count", null) : null
  node_count                   = lookup(each.value, "node_count", 0)
}
