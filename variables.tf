variable "resource_group_name" {
  description = "Resource group name that the AKS will be created in"
}

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "client_id" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
}

variable "client_secret" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
}

variable "agents_size" {
  default     = "Standard_F2"
  description = "The default virtual machine size for the Kubernetes agents"
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  default     = 30
}

variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool"
  default     = 2
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  default     = ""
}

variable "tags" {
  default     = {}
  description = "Any tags that should be present on the Virtual Network resources"
  type        = map(string)
}

