# terraform-azurerm-aks variables

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
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

variable "network_profile" {
  description = "Variables defining the AKS network profile config"
  type = object({
    network_plugin     = string
    network_policy     = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    pod_cidr           = string
    service_cidr       = string
  })
  default = {
    network_plugin     = "kubenet"
    network_policy     = ""
    dns_service_ip     = ""
    docker_bridge_cidr = ""
    pod_cidr           = ""
    service_cidr       = ""
  }
}

variable "tags" {
  default     = {}
  description = "Any tags that should be present on resources"
  type        = map(string)
}
