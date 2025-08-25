module "aks" {
  source             = "../../v4"
  rbac_aad_tenant_id = data.azurerm_client_config.current.tenant_id
}