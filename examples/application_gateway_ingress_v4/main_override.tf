module "aks" {
  #checkov:skip=CKV_AZURE_141:We enable admin account here so we can provision K8s resources directly in this simple example
  source             = "../../v4"
  rbac_aad_tenant_id = data.azurerm_client_config.this.tenant_id
}