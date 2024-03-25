resource "azurerm_role_assignment" "acr" {
  for_each = var.attached_acr_id_map

  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  scope                            = each.value
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

# /subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/acceptanceTestResourceGroup1/providers/Microsoft.ManagedIdentity/userAssignedIdentities/testIdentity
data "azurerm_user_assigned_identity" "cluster_identity" {
  count = (var.client_id == "" || var.client_secret == "") && var.identity_type == "UserAssigned" ? 1 : 0

  name                = split("/", var.identity_ids[0])[8]
  resource_group_name = split("/", var.identity_ids[0])[4]
}

# The AKS cluster identity has the Contributor role on the AKS second resource group (MC_myResourceGroup_myAKSCluster_eastus)
# However when using a custom VNET, the AKS cluster identity needs the Network Contributor role on the VNET subnets
# used by the system node pool and by any additional node pools.
# https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#prerequisites
# https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni#prerequisites
# https://github.com/Azure/terraform-azurerm-aks/issues/178
resource "azurerm_role_assignment" "network_contributor" {
  for_each = var.create_role_assignment_network_contributor && (var.client_id == "" || var.client_secret == "") ? local.subnet_ids : []

  principal_id         = coalesce(try(data.azurerm_user_assigned_identity.cluster_identity[0].principal_id, azurerm_kubernetes_cluster.main.identity[0].principal_id), var.client_id)
  scope                = each.value
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = length(var.network_contributor_role_assigned_subnet_ids) == 0
      error_message = "Cannot set both of `var.create_role_assignment_network_contributor` and `var.network_contributor_role_assigned_subnet_ids`."
    }
  }
}

resource "azurerm_role_assignment" "network_contributor_on_subnet" {
  for_each = var.network_contributor_role_assigned_subnet_ids

  principal_id         = coalesce(try(data.azurerm_user_assigned_identity.cluster_identity[0].principal_id, azurerm_kubernetes_cluster.main.identity[0].principal_id), var.client_id)
  scope                = each.value
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = !var.create_role_assignment_network_contributor
      error_message = "Cannot set both of `var.create_role_assignment_network_contributor` and `var.network_contributor_role_assigned_subnet_ids`."
    }
  }
}

data "azurerm_client_config" "this" {}

data "azurerm_virtual_network" "application_gateway_vnet" {
  count = var.create_role_assignments_for_application_gateway && local.use_brown_field_gw_for_ingress ? 1 : 0

  name                = local.existing_application_gateway_subnet_vnet_name
  resource_group_name = local.existing_application_gateway_subnet_resource_group_name
}

resource "azurerm_role_assignment" "application_gateway_existing_vnet_network_contributor" {
  count = var.create_role_assignments_for_application_gateway && local.use_brown_field_gw_for_ingress ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.main.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  scope                = data.azurerm_virtual_network.application_gateway_vnet[0].id
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = data.azurerm_client_config.this.subscription_id == local.existing_application_gateway_subnet_subscription_id_for_ingress
      error_message = "Application Gateway's subnet must be in the same subscription, or `var.application_gateway_for_ingress.create_role_assignments` must be set to `false`."
    }
  }
}

resource "azurerm_role_assignment" "application_gateway_byo_vnet_network_contributor" {
  count = var.create_role_assignments_for_application_gateway && local.use_green_field_gw_for_ingress ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.main.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  scope                = join("/", slice(local.default_nodepool_subnet_segments, 0, length(local.default_nodepool_subnet_segments) - 2))
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = var.green_field_application_gateway_for_ingress == null || !(var.create_role_assignments_for_application_gateway && var.vnet_subnet_id == null)
      error_message = "When `var.vnet_subnet_id` is `null`, you must set `var.create_role_assignments_for_application_gateway` to `false`, set `var.green_field_application_gateway_for_ingress` to `null`."
    }
  }
}

resource "azurerm_role_assignment" "existing_application_gateway_contributor" {
  count = var.create_role_assignments_for_application_gateway && local.use_brown_field_gw_for_ingress ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.main.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  scope                = var.brown_field_application_gateway_for_ingress.id
  role_definition_name = "Contributor"

  lifecycle {
    precondition {
      condition     = var.brown_field_application_gateway_for_ingress == null ? true : data.azurerm_client_config.this.subscription_id == local.existing_application_gateway_subscription_id_for_ingress
      error_message = "Application Gateway must be in the same subscription, or `var.create_role_assignments_for_application_gateway` must be set to `false`."
    }
  }
}

data "azurerm_resource_group" "ingress_gw" {
  count = var.create_role_assignments_for_application_gateway && local.use_brown_field_gw_for_ingress ? 1 : 0

  name = local.existing_application_gateway_resource_group_for_ingress
}

data "azurerm_resource_group" "aks_rg" {
  count = var.create_role_assignments_for_application_gateway ? 1 : 0

  name = var.resource_group_name
}

resource "azurerm_role_assignment" "application_gateway_resource_group_reader" {
  count = var.create_role_assignments_for_application_gateway && local.ingress_application_gateway_enabled ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.main.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  scope                = local.use_brown_field_gw_for_ingress ? data.azurerm_resource_group.ingress_gw[0].id : data.azurerm_resource_group.aks_rg[0].id
  role_definition_name = "Reader"
}
