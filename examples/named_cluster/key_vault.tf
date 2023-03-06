data "azurerm_client_config" "current" {}

resource "random_string" "key_vault_prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

data "curl" "public_ip" {
  count = var.key_vault_firewall_bypass_ip_cidr == null ? 1 : 0

  http_method = "GET"
  uri         = "https://api.ipify.org?format=json"
}

locals {
  # We cannot use coalesce here because it's not short-circuit and public_ip's index will cause error
  public_ip = var.key_vault_firewall_bypass_ip_cidr == null ? jsondecode(data.curl.public_ip[0].response).ip : var.key_vault_firewall_bypass_ip_cidr
}

resource "azurerm_key_vault" "des_vault" {
  location                    = local.resource_group.location
  name                        = "${random_string.key_vault_prefix.result}-des-keyvault"
  resource_group_name         = local.resource_group.name
  sku_name                    = "premium"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = [local.public_ip]
  }
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.des_vault.id
  object_id    = coalesce(var.managed_identity_principal_id, data.azurerm_client_config.current.object_id)
  tenant_id    = data.azurerm_client_config.current.tenant_id
  key_permissions = [
    "Get",
    "Create",
    "Delete",
    "GetRotationPolicy",
    "Recover",
  ]
}
