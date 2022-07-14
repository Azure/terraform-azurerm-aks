variable "client_id" {}

variable "client_secret" {}

variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = null
}

variable "location" {
  default = "eastus"
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}