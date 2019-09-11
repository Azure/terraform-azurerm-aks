provider "azurerm" {
  version = "~> 1.27"
}

resource "random_string" "prefix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "${random_string.prefix.result}-resources"
  location = "${var.location}"
}

module aks {
  source                      = "../.."
  prefix                      = "${random_string.prefix.result}"
  location                    = "${var.location}"
  CLIENT_ID                   = "${var.CLIENT_ID}"
  CLIENT_SECRET               = "${var.CLIENT_SECRET}"
  admin_username              = "${var.admin_username}"
  agents_size                 = "${var.agents_size}"
  log_analytics_workspace_sku = "${var.log_analytics_workspace_sku}"
  log_retention_in_days       = "${var.log_retention_in_days}"
}
