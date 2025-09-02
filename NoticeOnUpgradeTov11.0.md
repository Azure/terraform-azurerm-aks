# Notice on Upgrade to v11.0

## AzureRM provider v3 support has been removed

`v11.0.0` removed support for Terraform AzureRM provider `v3` and removed `//v4` folder. All users need to use `Azure/aks/azurerm` instead of `Azure/aks/azurerm//v4` as module `source`.

## `var.enable_auto_scaling` has been renamed to `var.auto_scaling_enabled`

This change also affects the `node_pools` variable where `node_pools[*].enable_auto_scaling` should be replaced with `node_pools[*].auto_scaling_enabled`.

## `var.enable_host_encryption` has been renamed to `var.host_encryption_enabled`

This change also affects the `node_pools` variable where `node_pools[*].enable_host_encryption` should be replaced with `node_pools[*].host_encryption_enabled`.

## `var.enable_node_public_ip` has been renamed to `var.node_public_ip_enabled`

This change also affects the `node_pools` variable where `node_pools[*].enable_node_public_ip` should be replaced with `node_pools[*].node_public_ip_enabled`.

## `cluster_identity` output is no longer marked as sensitive

The `cluster_identity` output was incorrectly marked as `sensitive = true` due to the `identity` block referencing `var.client_secret` in its `for_each` expression. This has been fixed by using the `nonsensitive()` function, and the output is no longer marked as sensitive.

**Impact**: Users who previously had to mark their outputs as sensitive when using `module.aks.cluster_identity` can now remove the `sensitive = true` flag from their outputs. The cluster identity information (principal_id, tenant_id, type) is not actually sensitive data.
