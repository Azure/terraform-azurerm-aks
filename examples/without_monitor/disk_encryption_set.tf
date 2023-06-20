data "azurerm_client_config" "current" {}

resource "random_string" "key_vault_prefix" {
  length  = 6
  numeric = false
  special = false
  upper   = false
}

module "public_ip" {
  source  = "lonegunmanb/public-ip/lonegunmanb"
  version = "0.1.0"
}

locals {
  # We cannot use coalesce here because it's not short-circuit and public_ip's index will cause error
  public_ip = var.key_vault_firewall_bypass_ip_cidr == null ? module.public_ip.public_ip : var.key_vault_firewall_bypass_ip_cidr
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

resource "azurerm_key_vault_key" "des_key" {
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  key_type        = "RSA-HSM"
  key_vault_id    = azurerm_key_vault.des_vault.id
  name            = "des-key"
  expiration_date = timeadd("${formatdate("YYYY-MM-DD", timestamp())}T00:00:00Z", "168h")
  key_size        = 2048

  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]

  lifecycle {
    ignore_changes = [expiration_date]
  }
}

resource "azurerm_disk_encryption_set" "des" {
  key_vault_key_id    = azurerm_key_vault_key.des_key.id
  location            = local.resource_group.location
  name                = "des"
  resource_group_name = local.resource_group.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "des" {
  key_vault_id = azurerm_key_vault.des_vault.id
  object_id    = azurerm_disk_encryption_set.des.identity[0].principal_id
  tenant_id    = azurerm_disk_encryption_set.des.identity[0].tenant_id
  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
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