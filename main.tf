provider "azurerm" {
  version = "=1.23.0"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
  count               = "${var.vnet_subnet_id == "" ? 1 : 0}"
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "main" {
  count                = "${var.vnet_subnet_id == "" ? 1 : 0}"
  name                 = "aks-subnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.1.0/24"
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = "${var.public_ssh_key == "" ? "" : var.public_ssh_key }"
}

module "kubernetes" {
  source                          = "./modules/kubernetes-cluster"
  prefix                          = "${var.prefix}"
  resource_group_name             = "${azurerm_resource_group.main.name}"
  location                        = "${azurerm_resource_group.main.location}"
  admin_username                  = "${var.admin_username}"
  admin_public_ssh_key            = "${var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key }"
  agents_size                     = "${var.agents_size}"
  agents_disk_size                = "${var.agents_disk_size}"
  agents_count                    = "${var.agents_count}"
  kubernetes_version              = "${var.kubernetes_version}"
  vnet_subnet_id                  = "${var.vnet_subnet_id == "" ? azurerm_subnet.main.id : var.vnet_subnet_id }"
  service_principal_client_id     = "${var.CLIENT_ID}"
  service_principal_client_secret = "${var.CLIENT_SECRET}"
  log_analytics_workspace_id      = "${module.log_analytics_workspace.id}"
}

module "log_analytics_workspace" {
  source              = "./modules/log-analytics-workspace"
  prefix              = "${var.prefix}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  location            = "${azurerm_resource_group.main.location}"
  retention_in_days   = "${var.log_retention_in_days}"
  sku                 = "${var.log_analytics_workspace_sku}"
}

module "log_analytics_solution" {
  source                = "./modules/log-analytics-solution"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  location              = "${azurerm_resource_group.main.location}"
  workspace_resource_id = "${module.log_analytics_workspace.id}"
  workspace_name        = "${module.log_analytics_workspace.name}"
}
