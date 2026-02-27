resource "random_id" "prefix" {
  byte_length = 8
}

resource "random_id" "name" {
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = coalesce(var.resource_group_name, "${random_id.prefix.hex}-rg")
}

locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }
}

resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "test" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
}

resource "azurerm_subnet" "node_pool_subnet" {
  count                                         = 2
  address_prefixes                              = ["10.52.${count.index + 1}.0/24"]
  name                                          = "${random_id.prefix.hex}-sn${count.index}"
  resource_group_name                           = local.resource_group.name
  virtual_network_name                          = azurerm_virtual_network.test.name
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}

locals {
  nodes = {
    for i in range(2) : "worker${i}" => {
      name                  = substr("worker${i}${random_id.prefix.hex}", 0, 8)
      vm_size               = "Standard_D4_v3"
      node_count            = 1
      vnet_subnet           = { id = azurerm_subnet.node_pool_subnet[i].id }
      create_before_destroy = i % 2 == 0
      upgrade_settings = {
        drain_timeout_in_minutes      = 0
        node_soak_duration_in_minutes = 0
        max_surge                     = "10%"
      }
    }
  }
}

module "aks" {
  source = "../.."

  location                          = local.resource_group.location
  prefix                            = random_id.name.hex
  rbac_aad_tenant_id                = data.azurerm_client_config.current.tenant_id
  resource_group_name               = local.resource_group.name
  kubernetes_version                = "1.33" # don't specify the patch version!
  automatic_channel_upgrade         = "patch"
  agents_count                      = null
  agents_max_count                  = 2
  agents_max_pods                   = 100
  agents_min_count                  = 1
  agents_pool_name                  = "testnodepool"
  agents_size                       = "Standard_D4_v3"
  auto_scaling_enabled              = true
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  log_analytics_workspace_enabled   = false
  net_profile_dns_service_ip        = "10.0.0.10"
  net_profile_service_cidr          = "10.0.0.0/16"
  node_pools                        = local.nodes
  network_plugin                    = "azure"
  orchestrator_version              = "1.30"
  os_disk_size_gb                   = 60
  private_cluster_enabled           = false
  role_based_access_control_enabled = true
  sku_tier                          = "Standard"
  vnet_subnet = {
    id = azurerm_subnet.test.id
  }

  # LocalDNS configuration example
  local_dns_config = { for k, v in local.nodes : k => {
    mode = "Required"

    # Configuration for pods using dnsPolicy:default (VNet DNS)
    vnet_dns_overrides = {
      "." = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "VnetDNS"
        forward_policy                  = "Random"
        max_concurrent                  = 150
        cache_duration_in_seconds       = 300
        serve_stale_duration_in_seconds = 86400
        serve_stale                     = "Immediate"
      }
      "cluster.local" = {
        query_logging                   = "Log"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "RoundRobin"
        max_concurrent                  = 100
        cache_duration_in_seconds       = 300
        serve_stale_duration_in_seconds = 86400
        serve_stale                     = "Immediate"
      }
    }

    # Configuration for pods using dnsPolicy:ClusterFirst (Kubernetes DNS)
    kube_dns_overrides = {
      "." = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "Sequential"
        max_concurrent                  = 200
        cache_duration_in_seconds       = 600
        serve_stale_duration_in_seconds = 3600
        serve_stale                     = "Immediate"
      }
      "cluster.local" = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "Sequential"
        max_concurrent                  = 200
        cache_duration_in_seconds       = 600
        serve_stale_duration_in_seconds = 3600
        serve_stale                     = "Verify"
      }
    }
  } }

  # LocalDNS configuration for the default (system) node pool
  agents_pool_local_dns_config = {
    mode = "Required"

    vnet_dns_overrides = {
      "." = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "VnetDNS"
        forward_policy                  = "Random"
        max_concurrent                  = 150
        serve_stale_duration_in_seconds = 86400
        cache_duration_in_seconds       = 600
        serve_stale                     = "Immediate"
      }
      "cluster.local" = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "Sequential"
        max_concurrent                  = 200
        cache_duration_in_seconds       = 600
        serve_stale_duration_in_seconds = 3600
        serve_stale                     = "Verify"
      }
    }

    kube_dns_overrides = {
      "." = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "Sequential"
        max_concurrent                  = 200
        cache_duration_in_seconds       = 600
        serve_stale_duration_in_seconds = 3600
        serve_stale                     = "Immediate"
      }
      "cluster.local" = {
        query_logging                   = "Error"
        protocol                        = "PreferUDP"
        forward_destination             = "ClusterCoreDNS"
        forward_policy                  = "Sequential"
        max_concurrent                  = 200
        cache_duration_in_seconds       = 600
        serve_stale_duration_in_seconds = 3600
        serve_stale                     = "Verify"
      }
    }
  }

  depends_on = [
    azurerm_subnet.test,
  ]
}

data "azurerm_client_config" "current" {}