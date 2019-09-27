# terraform-azurerm-aks/log-analytics-workspace variables

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group."
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Virtual Network"
}

variable "location" {
  description = "The Azure Region in which to create the Virtual Network"
}

variable "sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace"
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The retention period for the logs in days"
  default     = 30
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace"
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  default     = 30
}

