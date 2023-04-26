# Notice on Upgrade to v7.x

## Add validation block to enforce users to change `sku_tier` from `Paid` to `Standard`

AzureRM's minimum version is `>= 3.51, < 4.0` now.
[`var.sku_tier` cannot be set to `Paid` anymore](https://github.com/hashicorp/terraform-provider-azurerm/issues/20887), now possible values are `Free` and `Standard`.

## Ignore changes on `kubernetes_version` from outside of Terraform

Related issue: #335

Two new resources would be created when upgrading from v6.x to v7.x:

* `null_resource.kubernetes_version_keeper`
* `azapi_update_resource.aks_cluster_post_create`

`azurerm_kubernetes_cluster.main` resource would ignore change on `kubernetes_version` from outside of Terraform in case AKS cluster's patch version has been upgraded automatically.
When you change `var.kubernetes_version`'s value, it would trigger a re-creation of `null_resource.kubernetes_version_keeper` and re-creation of `azapi_update_resource.aks_cluster_post_create`, which would upgrade the AKS cluster's `kubernetes_version`.

`azapi` provider is required to be configured in your Terraform configuration.

## Fix #315 by amending missing `linux_os_config` block

In v6.0, `default_node_pool.linux_os_config` block won't be added to `azurerm_kubernetes_cluster.main` resource when `var.enable_auto_scaling` is `true`. This bug has been fixed in v7.0.0 so you might see a diff on `azurerm_kubernetes_cluster.main` resource.

##  Wrap `log_analytics_solution_id` to an object to fix #263.

`var.log_analytics_solution_id` is now an object with `id` attribute. This change is to fix #263.

## Remove unused net_profile_docker_bridge_cidr

`var.net_profile_docker_bridge_cidr` has been [deprecated](https://github.com/hashicorp/terraform-provider-azurerm/issues/18119) and is not used in the module anymore and has been removed.
