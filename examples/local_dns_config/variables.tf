variable "client_id" {
  description = "The Client ID which should be used."
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "The Client Secret which should be used."
  type        = string
  default     = ""
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "location" {
  default     = "eastus2"
  description = "The location where the Managed Kubernetes Cluster should be created."
}

variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
  default     = null
}