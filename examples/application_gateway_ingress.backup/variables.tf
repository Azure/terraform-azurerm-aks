variable "bring_your_own_vnet" {
  type    = bool
  default = true
}

variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "create_role_assignments_for_application_gateway" {
  type    = bool
  default = true
}

variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "use_brown_field_application_gateway" {
  type    = bool
  default = false
}
