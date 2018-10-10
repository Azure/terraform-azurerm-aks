variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "location" {
  default = "eastus"
  description = "The location for the AKS deployment"
}

variable "CLIENT_ID" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
}

variable "CLIENT_SECRET" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
}

variable "admin_username" {
  default = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
}

variable "agents_size" {
  default = "Standard_F2"
  description = "The default virtual machine size for the Kubernetes agents"
}


variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace"
  default = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  default = 30
}

