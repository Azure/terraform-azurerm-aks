
provider "azuread" {
  version = ">=0.6.0"
}

# =============================================
# Service Principle
# =============================================

resource "azuread_application" "aks_service_principle" {
  name                       = "${var.name}-aks-sp"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "aks_service_principle" {
  application_id = azuread_application.aks_service_principle.application_id
}

resource "random_password" "aks_service_principle" {
  length  = 16
  special = true
}

resource "azuread_service_principal_password" "aks_service_principle" {
  service_principal_id = azuread_service_principal.aks_service_principle.id
  value                = random_password.aks_service_principle.result
  end_date             = "2020-01-01T01:02:03Z"
}

# =============================================
# main
# =============================================

module "aks" {
  source = "../../"
  #   source = "github.com/Azure/terraform-azurerm-aks?ref=v2.0"

  prefix             = var.name
  kubernetes_version = local.aks_version
  CLIENT_ID          = azuread_application.aks_service_principle.application_id
  CLIENT_SECRET      = random_password.aks_service_principle.result
}
