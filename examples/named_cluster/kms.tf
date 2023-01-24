resource "azurerm_key_vault_key" "kms" {
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  key_type     = "RSA"
  key_vault_id = azurerm_key_vault.des_vault.id
  name         = "etcd-encryption"
  key_size     = 2048

  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}

resource "azurerm_key_vault_access_policy" "kms" {
  key_vault_id = azurerm_key_vault.des_vault.id
  object_id    = azurerm_user_assigned_identity.test.id
  tenant_id    = azurerm_user_assigned_identity.test.tenant_id
  key_permissions = [
    "Decrypt",
    "Encrypt",
  ]
}
