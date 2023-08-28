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

## Add `create_before_destroy=true` to node pools #357

Now `azurerm_kubernetes_cluster_node_pool.node_pool` resource has `create_before_destroy=true` to avoid downtime when upgrading node pools. Users must be aware that there would be a "random" suffix added into pool's name, this suffix's length is `4`, so your previous node pool's name `nodepool1` would be `nodepool1xxxx`. This suffix is calculated from node pool's config, the same configuration would lead to the same suffix. You might need to shorten your node pool's name because of this new added suffix.

To enable this feature, we've also added new `null_resource.pool_name_keeper` to track node pool's name in case you've changed the name.

## Check `api_server_authorized_ip_ranges` when `public_network_access_enabled` is `true` #361

As the [document](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#public_network_access_enabled) described:

>When `public_network_access_enabled` is set to true, `0.0.0.0/32` must be added to `authorized_ip_ranges` in the `api_server_access_profile block`.

We'll add `api_server_access_profile` nested block after AzureRM provider's v4.0, but starting from v7.0 we'll enforce such pre-condition check.

## Add `depends_on` to `azurerm_kubernetes_cluster_node_pool` resources #418

If you have `azurerm_kubernetes_cluster_node_pool` resources not managed with this module (`var.nodepools`) you
must have an explicit `depends_on` on those resources to avoid conflicting nodepools operations.
See issue #418 for more details.
