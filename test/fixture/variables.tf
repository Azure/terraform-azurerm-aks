variable "client_id" {}

variable "client_secret" {}

variable "key_vault_firewall_bypass_ip_cidr" {
  type        = string
  description = "This Terraform script will provision a new Azure KeyVault key so this machine's public ip should be put into KeyVault's firewall allow list."
}

variable "location" {
  default = "eastus"
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}