variable "default_node_pool" {
    description = "(Optional) This var sets the default_node_pool config block."
    type        = list(object({     
      orchestrator_version  = string
      name                  = string
      node_count            = number
      vm_size               = string
      os_disk_size_gb       = number
      vnet_subnet_id        = string
      enable_node_public_ip = bool
      enable_auto_scaling   = bool
      availability_zones    = list(string)
      node_labels           = map(string)
      node_taints           = list(string)
      type                  = string
      tags                  = map(string)
      max_pods              = number
      max_count             = number
      min_count             = number    
    }))
    default     = [{
      orchestrator_version  = null
      name                  = "nodepool"
      node_count            = 2
      vm_size               = "Standard_D2s_v3"
      os_disk_size_gb       = 50
      vnet_subnet_id        = null
      enable_node_public_ip = null
      enable_auto_scaling   = null
      availability_zones    = null
      node_labels           = null
      node_taints           = null
      type                  = null
      tags                  = null
      max_pods              = null
      max_count             = null
      min_count             = null
    }]
##    Example:
#
#     default = [{
#       orchestrator_version  = null
#       name                  = "default"
#       node_count            = 3
#       vm_size               = "Standard_D2s_v3"
#       os_disk_size_gb       = 50
#       vnet_subnet_id        = null
#       enable_node_public_ip = null
#       enable_auto_scaling   = true
#       availability_zones    = null
#       node_labels           = null
#       node_taints           = null
#       type                  = null
#       tags                  = null
#       max_pods              = null
#       max_count             = 10
#       min_count             = 2
# }]
}