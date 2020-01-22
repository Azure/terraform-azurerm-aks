resource "random_string" "prefix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "${random_string.prefix.result}-rg"
  location = var.location
}

module aks {
  source                      = "../.."
  prefix                      = "pre-${random_string.prefix.result}"
  location                    = var.location
  admin_username              = var.admin_username
  agents_size                 = var.agents_size
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  log_retention_in_days       = var.log_retention_in_days
}
