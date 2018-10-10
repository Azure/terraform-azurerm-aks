resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "Containers"
  workspace_name      = "${var.prefix}-log-analytics-workspace"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  workspace_resource_id = "${var.workspace_resource_id}"
  workspace_name        = "${var.workspace_name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}