variable "resource_group_name" {
  type        = string
  description = "The resource group name to be imported"
}

variable "cluster_name" {
  type        = string
  description = "The name for the AKS cluster"
}

variable "additional_node_pools" {
  description = "Specify a map of node pools where key - the name if the pool, value - the object which represents the parameters for pool`s configuration. Dy default nothing will be createdy"
  type        = map(any)
  default     = {}
}