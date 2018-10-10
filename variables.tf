variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group."
}

variable "location" {
  default = "eastus"
}

variable "app_replicas" {
  default = 1
}

variable "CLIENT_ID" {}
variable "CLIENT_SECRET" {}
