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
