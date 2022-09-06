## 5.0.0 (July 14, 2022)

ENHANCEMENTS:

* Variable `enable_kube_dashboard` has been removed as [#181](https://github.com/Azure/terraform-azurerm-aks/issues/181) described. ([#187](https://github.com/Azure/terraform-azurerm-aks/pull/187))
* Add new variable `location` so we can define location for the resources explicitly. ([#172](https://github.com/Azure/terraform-azurerm-aks/pull/172))
* Bump AzureRM Provider version to 3.3.0.  ([#157](https://github.com/Azure/terraform-azurerm-aks/pull/157))
* Add new variable `private_dns_zone_id` to make argument `private_dns_zone_id` configurable. ([#174](https://github.com/Azure/terraform-azurerm-aks/pull/174))
* Add new variable `open_service_mesh_enabled` to make argument `open_service_mesh_enabled` configurable. ([#132](https://github.com/Azure/terraform-azurerm-aks/pull/132))
* Remove `addon_profile` in the outputs since the block has been removed from provider 3.x. Extract embedded blocks inside `addon_profile` block into standalone outputs. ([#188](https://github.com/Azure/terraform-azurerm-aks/pull/188))
* Add `nullable = true` to some variables to simplify the conditional expressions. ([#193](https://github.com/Azure/terraform-azurerm-aks/pull/193))
* Add new variable `oidc_issuer_enabled` to make argument `oidc_issuer_enabled` configurable. ([#205](https://github.com/Azure/terraform-azurerm-aks/pull/205)
* Add new output `oidc_issuer_url` to expose the created issuer URL from the module. [#206](https://github.com/Azure/terraform-azurerm-aks/pull/206))
* Turn monitoring on in the test code. ([#201](https://github.com/Azure/terraform-azurerm-aks/pull/201))
* Add new variables `private_dns_zone_id` and `private_cluster_public_fqdn_enabled` to make arguments `private_dns_zone_id` and `private_cluster_public_fqdn_enabled` configurable. ([#149](https://github.com/Azure/terraform-azurerm-aks/pull/149))
* Remove `module.ssh-key` and moves resource `tls_private_key` inside the module to root directory, then outputs tls keys. ([#189](https://github.com/Azure/terraform-azurerm-aks/pull/189))
* Add new variables `rbac_aad_azure_rbac_enabled` and `rbac_aad_tenant_id` to make arguments in `azure_active_directory_role_based_access_control` configurable. ([#199](https://github.com/Azure/terraform-azurerm-aks/pull/199))
* Add `count` meta-argument to resource `tls_private_key` to avoid the unnecessary creation. ([#209](https://github.com/Azure/terraform-azurerm-aks/pull/209))
* Add new variable `only_critical_addons_enabled` to make argument `only_critical_addons_enabled` in block `default_node_pool` configurable. ([#129](https://github.com/Azure/terraform-azurerm-aks/pull/129))
* Add support for the argument `key_vault_secrets_provider`. ([#214](https://github.com/Azure/terraform-azurerm-aks/pull/214))
* Provides a way to attach existing Log Analytics Workspace to AKS through Container Insights. ([#213](https://github.com/Azure/terraform-azurerm-aks/pull/213))
* Add new variable `local_account_disabled` to make argument `local_account_disabled` configurable. ([#218](https://github.com/Azure/terraform-azurerm-aks/pull/218))
* Set argument `private_cluster_enabled` to `true` in the test code. ([#219](https://github.com/Azure/terraform-azurerm-aks/pull/219))
* Add new variable `disk_encryption_set_id` to make argument `disk_encryption_set_id` configurable. Create resource `azurerm_disk_encryption_set` in the test code to turn disk encryption on for the cluster. ([#195](https://github.com/Azure/terraform-azurerm-aks/pull/195))
* Add new variable `api_server_authorized_ip_ranges` to make argument `api_server_authorized_ip_ranges` configurable. ([#220](https://github.com/Azure/terraform-azurerm-aks/pull/220))
* Rename output `system_assigned_identity` to `cluster_identity` since it could be user assigned identity. Remove the index inside output's value expression. ([#197](https://github.com/Azure/terraform-azurerm-aks/pull/197))
* Rename `var.enable_azure_policy` to `var.azure_policy_enabled` to meet the naming convention. Set `azure_policy_enabled` to `true` in test fixture code. ([#203](https://github.com/Azure/terraform-azurerm-aks/pull/203))

BUG FIXES:

* Change the incorrect description of variable `tags`. ([#175](https://github.com/Azure/terraform-azurerm-aks/pull/175))
