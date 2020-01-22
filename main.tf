data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

module "kubernetes" {
  source                          = "./modules/kubernetes-cluster"
  prefix                          = var.prefix
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  admin_username                  = var.admin_username
  admin_public_ssh_key            = var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key
  agents_size                     = var.agents_size
  agents_count                    = var.agents_count
  service_principal_client_id     = var.ARM_CLIENT_ID
  service_principal_client_secret = var.ARM_CLIENT_SECRET
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-log-analytics-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days
}

resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}


