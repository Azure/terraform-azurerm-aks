# Notice on Upgrade to v5.x

V5.0.0 is a major version upgrade and a lot of breaking changes have been introduced. Extreme caution must be taken during the upgrade to avoid resource replacement and downtime by accident.

Running the `terraform plan` first to inspect the plan is strongly advised.

## Terraform and terraform-provider-azurerm version restrictions

Now Terraform core's lowest version is v1.2.0 and terraform-provider-azurerm's lowest version is v3.21.0.

## variable `user_assigned_identity_id` has been renamed.

variable `user_assigned_identity_id` has been renamed to `identity_ids` and it's type has been changed from `string` to `list(string)`.

## `addon_profile` in outputs is no longer available.

It has been broken into the following new outputs:

* `aci_connector_linux`
* `aci_connector_linux_enabled`
* `azure_policy_enabled`
* `http_application_routing_enabled`
* `ingress_application_gateway`
* `ingress_application_gateway_enabled`
* `key_vault_secrets_provider`
* `key_vault_secrets_provider_enabled`
* `oms_agent`
* `oms_agent_enabled`
* `open_service_mesh_enabled`

## The following variables have been renamed from `enable_xxx` to `xxx_enabled`

* `enable_azure_policy` has been renamed to `azure_policy_enabled`
* `enable_http_application_routing` has been renamed to `http_application_routing_enabled`
* `enable_ingress_application_gateway` has been renamed to `ingress_application_gateway_enabled`
* `enable_log_analytics_workspace` has been renamed to `log_analytics_workspace_enabled`
* `enable_open_service_mesh` has been renamed to `open_service_mesh_enabled`
* `enable_role_based_access_control` has been renamed to `role_based_access_control_enabled`

## `nullable = true` has been added to the following variables so setting them to `null` explicitly will use the default value

* `log_analytics_workspace_enable`
* `os_disk_type`
* `private_cluster_enabled`
* `rbac_aad_managed`
* `rbac_aad_admin_group_object_ids`
* `network_policy`
* `enable_node_public_ip`

## `var.admin_username`'s default value has been removed

In v4.x `var.admin_username` has a default value `azureuser` and has been removed in V5.0.0. Since the `admin_username` argument in `linux_profile` block is a ForceNew argument, any value change to this argument will trigger a Kubernetes cluster replacement **SO THE EXTREME CAUTION MUST BE TAKEN**. The module's callers must set `var.admin_username` to `azureuser` explicitly if they didn't set it before.

## `module.ssh-key` has been removed

The file named `private_ssh_key` which contains the tls private key will be deleted since the `local_file` resource has been removed. Now the private key is exported via `generated_cluster_private_ssh_key` in output and the corresponding public key is exported via `generated_cluster_public_ssh_key` in output.

A `moved` block has been added to relocate the existing `tls_private_key` resource to the new address. If the `var.admin_username` is not `null`, no action is needed.

Resource `tls_private_key`'s creation now is conditional. Users may see the destruction of existing `tls_private_key` in the generated plan if `var.admin_username` is `null`.

## `system_assigned_identity` in the output has been renamed to `cluster_identity`

The `system_assigned_identity` was:

```hcl
output "system_assigned_identity" {
  value = azurerm_kubernetes_cluster.main.identity
}
```

Now it has been renamed to `cluster_identity`, and the block has been changed to:

```hcl
output "cluster_identity" {
  description = "The `azurerm_kubernetes_cluster`'s `identity` block."
  value       = try(azurerm_kubernetes_cluster.main.identity[0], null)
}
```

The callers who used to read the cluster's identity block need to remove the index in their expression, from `module.aks.system_assigned_identity[0]` to `module.aks.cluster_identity`.

## The following outputs are now sensitive. All outputs referenced them must be declared as sensitive too

* `client_certificate`
* `client_key`
* `cluster_ca_certificate`
* `generated_cluster_private_ssh_key`
* `host`
* `kube_admin_config_raw`
* `kube_config_raw`
* `password`
* `username`
