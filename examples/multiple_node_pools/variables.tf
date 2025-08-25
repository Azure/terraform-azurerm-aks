variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "location" {
  default = "centralus"
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "orchestrator_version" {
  type    = string
  default = null
}
