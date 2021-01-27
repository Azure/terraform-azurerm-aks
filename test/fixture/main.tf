// Cluster with monitoring and additonal node pools
module "aks" {
  source                          = "../.."
  prefix                          = "prefix-${random_id.prefix.hex}"
  resource_group_name             = azurerm_resource_group.main.name
  client_id                       = azuread_application.this.application_id
  client_secret                   = azuread_service_principal_password.this.value
  kubernetes_version              = "1.19.3"
  orchestrator_version            = "1.19.3"
  network_plugin                  = "azure"
  vnet_subnet_id                  = azurerm_subnet.test.id
  os_disk_size_gb                 = 60
  enable_http_application_routing = true
  enable_azure_policy             = true
  sku_tier                        = "Paid"
  private_cluster_enabled         = true
  enable_auto_scaling             = true
  agents_min_count                = 1
  agents_max_count                = 2
  agents_count                    = null
  agents_max_pods                 = 100
  agents_pool_name                = "testnodepool"
  agents_availability_zones       = ["1", "2"]
  agents_type                     = "VirtualMachineScaleSets"

  agents_labels = {
    "node1" : "label1"
  }

  agents_tags = {
    "Agent" : "agentTag"
  }

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  node_pools = {
    nodepool1 = {
      vm_size             = "Standard_DS2_v2"
      node_count          = 1
      enable_auto_scaling = true
      max_count           = 5
      min_count           = 2
    }
    nodepool2 = {
      vm_size    = "Standard_DS2_v2"
      node_count = 1
    }
  }

  depends_on = [azurerm_resource_group.main]
}


// cluster with default node pool and no monitoring
module "aks_without_monitor" {
  source                         = "../.."
  prefix                         = "prefix2-${random_id.prefix.hex}"
  resource_group_name            = azurerm_resource_group.main.name
  enable_log_analytics_workspace = false
  enable_kube_dashboard          = false
  net_profile_pod_cidr           = "10.1.0.0/16"
  depends_on                     = [azurerm_resource_group.main]
}

