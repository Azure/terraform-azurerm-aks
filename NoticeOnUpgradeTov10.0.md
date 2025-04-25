# Notice on Upgrade to v10.x

## AzAPI provider version constraint has been updated to `>=2.0, < 3.0`.

## [`var.web_app_routing` type change](https://github.com/Azure/terraform-azurerm-aks/pull/606)

`var.web_app_routing.dns_zone_id` has been replaced by `var.web_app_routing.dns_zone_ids`. The new variable is a list of DNS zone IDs. This change allows for the specification of multiple DNS zones for routing.

## [`data.azurerm_resource_group.main` in this module has been removed, `var.location` is a required variable now.](https://github.com/Azure/terraform-azurerm-aks/pull/644)

## [Create log analytics workspace would also create required monitor data collection rule now](https://github.com/Azure/terraform-azurerm-aks/pull/623)

The changes in this pull request introduce support for a Data Collection Rule (DCR) for Azure Monitor Container Insights in the Terraform module.

## [`CHANGELOG.md` file is no longer maintained, please read release note in GitHub repository instead](https://github.com/Azure/terraform-azurerm-aks/pull/651)

[New release notes](https://github.com/Azure/terraform-azurerm-aks/releases).

## [The following variables have been removed:](https://github.com/Azure/terraform-azurerm-aks/pull/652)

* `agents_taints`
* `api_server_subnet_id`
* `private_cluster_enabled`
* `rbac_aad_client_app_id`
* `rbac_aad_managed`
* `rbac_aad_server_app_id`
* `rbac_aad_server_app_secret`

## `var.pod_subnet_id` has been replaced by `var.pod_subnet.id`

## `var.vnet_subnet_id` has been replaced by `var.vnet_subnet.id`

## `var.node_pools.pod_subnet_id` has been replaced by `var.node_pools.pod_subnet.id`

## `var.node_pools.vnet_subnet_id` has been replaced by `var.node_pools.vnet_subnet.id`

## `azurerm_role_assignment.network_contributor` will be re-created

Since `for_each`'s target has been changed from a set of string to a map of object to avoid "Known after apply" values in iterator, we have to re-create the `azurerm_role_assignment.network_contributor` resource. This will cause the role assignment to be removed and re-added, which may result in a brief period of time where the role assignment is not present.

## When `var.create_role_assignment_network_contributor` is `true`, you must set different subnet for different node pools, include default pool, otherwise you must set `var.create_role_assignment_network_contributor` to `false` and manage role assignments yourself.

## `var.client_secret` now is `sensitive`

## @zioproto is no longer a maintainer of this module

For personal reasons, @zioproto is no longer a maintainer of this module. I want to express my sincere gratitude for his contributions and support over the years. His dedication and hard work are invaluable to this module.

THANK YOU @zioproto !
