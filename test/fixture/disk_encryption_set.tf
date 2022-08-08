data "azurerm_client_config" "current" {}

resource "random_string" "key_vault_prefix" {
  length  = 6
  numeric = false
  special = false
  upper   = false
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
  name                        = "${random_string.key_vault_prefix.result}-des-keyvault"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
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

resource "azurerm_key_vault_key" "des_key" {
  name         = "des-key"
  key_vault_id = azurerm_key_vault.des_vault.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  expiration_date = timeadd("${formatdate("YYYY-MM-DD", timestamp())}T00:00:00Z", "168h")

  lifecycle {
    ignore_changes = [expiration_date]
  }

  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}

resource "azurerm_disk_encryption_set" "des" {
  name                = "des"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  key_vault_key_id    = azurerm_key_vault_key.des_key.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "des" {
  key_vault_id = azurerm_key_vault.des_vault.id
  tenant_id    = azurerm_disk_encryption_set.des.identity[0].tenant_id
  object_id    = azurerm_disk_encryption_set.des.identity[0].principal_id
  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.des_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = coalesce(var.managed_identity_principal_id, data.azurerm_client_config.current.object_id)
  key_permissions = [
    "Get",
    "Create",
    "Delete",
  ]
}