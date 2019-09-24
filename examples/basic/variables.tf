variable "name" {
  description = "Moniker to apply to all resources in module"
  type        = string
  default     = "testkube"
}

variable "location" {
  description = "Name of file holding tfstate, should be unique for every tf module"
  type        = string
  default     = "eastus"
}

variable "k8s_version_prefix" {
  description = "Minor Version of Kubernetes to target (ex: 1.14)"
  type        = string
  default     = "1.14"
}

data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = var.k8s_version_prefix
}

locals {
  aks_version = data.azurerm_kubernetes_service_versions.current.latest_version
}
