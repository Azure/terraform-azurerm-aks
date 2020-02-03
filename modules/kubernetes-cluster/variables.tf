# terraform-azurerm-aks/kubernetes-cluster variables

variable "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace Id."
}

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group."
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Virtual Network"
}

variable "rbac_enabled" {
  default     = true
  description = "Boolean to enable or disable role-based access control"
  type        = bool
}

variable "location" {
  description = "The Azure Region in which to create the Virtual Network"
}

variable "tags" {
  default     = {}
  description = "Any tags that should be present on the Virtual Network resources"
  type        = map(string)
}

variable "admin_username" {
  description = "The username of the local administrator to be created on the Kubernetes cluster"
}

variable "admin_public_ssh_key" {
  description = "The SSH key to be used for the username defined in the `admin_username` variable."
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to install"
  default     = "1.11.3"
}

variable "service_principal_client_id" {
  description = "The Client ID of the Service Principal assigned to Kubernetes"
}

variable "service_principal_client_secret" {
  description = "The Client Secret of the Service Principal assigned to Kubernetes"
}

variable "agent_pool_profile" {
  description = "An agent_pool_profile block"
  type        = any
}

variable "default_node_pool" {
  description = "An default_node_pool block"
  type        = any
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
#   default     = []
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
}
