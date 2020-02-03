# terraform-azurerm-aks variables

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
}

variable "rbac_enabled" {
  default     = true
  description = "Boolean to enable or disable role-based access control"
  type        = bool
}

variable "location" {
  default     = "eastus"
  description = "The location for the AKS deployment"
  type        = string
}

variable "CLIENT_ID" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
  type        = string
}

variable "CLIENT_SECRET" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
  type        = string
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  default     = "PerGB2018"
  type        = string
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  default     = 30
  type        = number
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to install"
  default     = "1.14.5"
  type        = string
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  default     = ""
  type        = string
}

variable "agent_pool_profile" {
  description = "An agent_pool_profile block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#agent_pool_profile"
  type        = list(any)
  default = [{
    name            = "nodepool"
    count           = 1
    vm_size         = "standard_f2"
    os_type         = "Linux"
    agents_count    = 2
    os_disk_size_gb = 50
  }]
}

variable "default_node_pool" {
  description = "A default_node_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#default_node_pool"
  type        = map(any)
  default = {
    name                = "nodepool"
    vm_size             = "standard_f2"
    enable_auto_scaling = true
    os_disk_size_gb     = 50
    type                = "VirtualMachineScaleSets"
  }
}

variable "default_node_pool_availability_zones" {
  description = "The default_node_pools AZs"
  type        = list(string)
  default     = null
}

variable "default_node_pool_node_taints" {
  description = "The default_node_pools node taints"
  type        = list(string)
  default     = null
}

# variable "aks_ignore_changes" {
#   description = "lifecycle.aks_ignore_changes to ignore"
#   type        = list(string)
#   default     = [""]
# }

variable "network_profile" {
  description = "Variables defining the AKS network profile config"
  type = object({
    network_plugin     = string
    network_policy     = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    pod_cidr           = string
    service_cidr       = string
    load_balancer_sku  = string
  })
  default = {
    network_plugin     = "kubenet"
    network_policy     = ""
    dns_service_ip     = ""
    docker_bridge_cidr = ""
    pod_cidr           = ""
    service_cidr       = ""
    load_balancer_sku  = "Basic"
  }
}

variable "tags" {
  default     = {}
  description = "Any tags that should be present on resources"
  type        = map(string)
}
