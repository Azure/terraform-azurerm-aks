# terraform-azurerm-aks

## Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

-> **NOTE:** If you have not assigned `client_id` or `client_secret`, A `SystemAssigned` identity will be created.

## Notice on breaking changes

Please be aware that major version(e.g., from 6.8.0 to 7.0.0) update contains breaking changes that may impact your infrastructure. It is crucial to review these changes with caution before proceeding with the upgrade.

In most cases, you will need to adjust your Terraform code to accommodate the changes introduced in the new major version. We strongly recommend reviewing the changelog and migration guide to understand the modifications and ensure a smooth transition.

To help you in this process, we have provided detailed documentation on the breaking changes, new features, and any deprecated functionalities. Please take the time to read through these resources to avoid any potential issues or disruptions to your infrastructure.

* [Notice on Upgrade to v7.x](./NoticeOnUpgradeTov7.0.md)
* [Notice on Upgrade to v6.x](./NoticeOnUpgradeTov6.0.md)
* [Notice on Upgrade to v5.x](./NoticeOnUpgradeTov5.0.md)

Remember, upgrading to a major version with breaking changes should be done carefully and thoroughly tested in your environment. If you have any questions or concerns, please don't hesitate to reach out to our support team for assistance.

## Usage in Terraform 1.2.0

Please view folders in `examples`.

The module supports some outputs that may be used to configure a kubernetes
provider after deploying an AKS cluster.

```hcl
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}
```

There're some examples in the examples folder. You can execute `terraform apply` command in `examples`'s sub folder to try the module. These examples are tested against every PR with the [E2E Test](#Pre-Commit--Pr-Check--Test).

## Enable or disable tracing tags

We're using [BridgeCrew Yor](https://github.com/bridgecrewio/yor) and [yorbox](https://github.com/lonegunmanb/yorbox) to help manage tags consistently across infrastructure as code (IaC) frameworks. In this module you might see tags like:

```hcl
resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = random_pet.name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "3077cc6d0b70e29b6e106b3ab98cee6740c916f6"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-05 08:57:54"
    avm_git_org              = "lonegunmanb"
    avm_git_repo             = "terraform-yor-tag-test-module"
    avm_yor_trace            = "a0425718-c57d-401c-a7d5-f3d88b2551a4"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}
```

To enable tracing tags, set the variable to true:

```hcl
module "example" {
  source               = "{module_source}"
  ...
  tracing_tags_enabled = true
}
```

The `tracing_tags_enabled` is default to `false`.

To customize the prefix for your tracing tags, set the `tracing_tags_prefix` variable value in your Terraform configuration:

```hcl
module "example" {
  source              = "{module_source}"
  ...
  tracing_tags_prefix = "custom_prefix_"
}
```

The actual applied tags would be:

```text
{
  custom_prefix_git_commit           = "3077cc6d0b70e29b6e106b3ab98cee6740c916f6"
  custom_prefix_git_file             = "main.tf"
  custom_prefix_git_last_modified_at = "2023-05-05 08:57:54"
  custom_prefix_git_org              = "lonegunmanb"
  custom_prefix_git_repo             = "terraform-yor-tag-test-module"
  custom_prefix_yor_trace            = "a0425718-c57d-401c-a7d5-f3d88b2551a4"
}
```

## Pre-Commit & Pr-Check & Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirement(We strongly recommend you run the following command before you commit):

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

To follow [**Ensure AKS uses disk encryption set**](https://docs.bridgecrew.io/docs/ensure-that-aks-uses-disk-encryption-set) policy we've used `azurerm_key_vault` in example codes, and to follow [**Key vault does not allow firewall rules settings**](https://docs.bridgecrew.io/docs/ensure-that-key-vault-allows-firewall-rules-settings) we've limited the ip cidr on it's `network_acls`. On default we'll use the ip return by `https://api.ipify.org?format=json` api as your public ip, but in case you need use other cidr, you can assign on by passing an environment variable:

```text
docker run --rm -v $(pwd):/src -w /src -e TF_VAR_key_vault_firewall_bypass_ip_cidr="<your_cidr>" -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:
```text
docker run --rm -v ${pwd}:/src -w /src -e TF_VAR_key_vault_firewall_bypass_ip_cidr="<your_cidr>" -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

## Authors

Originally created by [Damien Caro](http://github.com/dcaro) and [Malte Lantin](http://github.com/n01d)

## License

[MIT](LICENSE)

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Module Spec

The following sections are generated by [terraform-docs](https://github.com/terraform-docs/terraform-docs) and [markdown-table-formatter](https://github.com/nvuillam/markdown-table-formatter), please **DO NOT MODIFY THEM MANUALLY!**

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version          |
|---------------------------------------------------------------------------|------------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3           |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi)             | >= 1.4.0, < 2.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.51.0, < 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null)                | >= 3.0           |
| <a name="requirement_tls"></a> [tls](#requirement\_tls)                   | >= 3.1           |

## Providers

| Name                                                          | Version          |
|---------------------------------------------------------------|------------------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi)       | >= 1.4.0, < 2.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.51.0, < 4.0 |
| <a name="provider_null"></a> [null](#provider\_null)          | >= 3.0           |
| <a name="provider_tls"></a> [tls](#provider\_tls)             | >= 3.1           |

## Modules

No modules.

## Resources

| Name                                                                                                                                                           | Type        |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [azapi_update_resource.aks_cluster_post_create](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource)                     | resource    |
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)                          | resource    |
| [azurerm_kubernetes_cluster_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource    |
| [azurerm_log_analytics_solution.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution)                  | resource    |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)                | resource    |
| [azurerm_role_assignment.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)                                 | resource    |
| [azurerm_role_assignment.network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)                 | resource    |
| [azurerm_role_assignment.network_contributor_on_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)       | resource    |
| [null_resource.kubernetes_version_keeper](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                               | resource    |
| [null_resource.pool_name_keeper](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                                        | resource    |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)                                                 | resource    |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace)             | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)                               | data source |
| [azurerm_user_assigned_identity.cluster_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity)   | data source |

## Outputs

| Name                                                                                                                                                                                                   | Description                                                                                                                                                                                                                                                                                                                                                                                                       |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a name="output_aci_connector_linux"></a> [aci\_connector\_linux](#output\_aci\_connector\_linux)                                                                                                      | The `aci_connector_linux` block of `azurerm_kubernetes_cluster` resource.                                                                                                                                                                                                                                                                                                                                         |
| <a name="output_aci_connector_linux_enabled"></a> [aci\_connector\_linux\_enabled](#output\_aci\_connector\_linux\_enabled)                                                                            | Has `aci_connector_linux` been enabled on the `azurerm_kubernetes_cluster` resource?                                                                                                                                                                                                                                                                                                                              |
| <a name="output_admin_client_certificate"></a> [admin\_client\_certificate](#output\_admin\_client\_certificate)                                                                                       | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block.  Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                           |
| <a name="output_admin_client_key"></a> [admin\_client\_key](#output\_admin\_client\_key)                                                                                                               | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                           |
| <a name="output_admin_cluster_ca_certificate"></a> [admin\_cluster\_ca\_certificate](#output\_admin\_cluster\_ca\_certificate)                                                                         | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster.                                                                                                                                                                                                                          |
| <a name="output_admin_host"></a> [admin\_host](#output\_admin\_host)                                                                                                                                   | The `host` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. The Kubernetes cluster server host.                                                                                                                                                                                                                                                                                                   |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password)                                                                                                                       | The `password` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. A password or token used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                               |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username)                                                                                                                       | The `username` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. A username used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                        |
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id)                                                                                                                                               | The `azurerm_kubernetes_cluster`'s id.                                                                                                                                                                                                                                                                                                                                                                            |
| <a name="output_aks_name"></a> [aks\_name](#output\_aks\_name)                                                                                                                                         | The `aurerm_kubernetes-cluster`'s name.                                                                                                                                                                                                                                                                                                                                                                           |
| <a name="output_azure_policy_enabled"></a> [azure\_policy\_enabled](#output\_azure\_policy\_enabled)                                                                                                   | The `azurerm_kubernetes_cluster`'s `azure_policy_enabled` argument. Should the Azure Policy Add-On be enabled? For more details please visit [Understand Azure Policy for Azure Kubernetes Service](https://docs.microsoft.com/en-ie/azure/governance/policy/concepts/rego-for-aks)                                                                                                                               |
| <a name="output_azurerm_log_analytics_workspace_id"></a> [azurerm\_log\_analytics\_workspace\_id](#output\_azurerm\_log\_analytics\_workspace\_id)                                                     | The id of the created Log Analytics workspace                                                                                                                                                                                                                                                                                                                                                                     |
| <a name="output_azurerm_log_analytics_workspace_name"></a> [azurerm\_log\_analytics\_workspace\_name](#output\_azurerm\_log\_analytics\_workspace\_name)                                               | The name of the created Log Analytics workspace                                                                                                                                                                                                                                                                                                                                                                   |
| <a name="output_azurerm_log_analytics_workspace_primary_shared_key"></a> [azurerm\_log\_analytics\_workspace\_primary\_shared\_key](#output\_azurerm\_log\_analytics\_workspace\_primary\_shared\_key) | Specifies the workspace key of the log analytics workspace                                                                                                                                                                                                                                                                                                                                                        |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate)                                                                                                           | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                  |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key)                                                                                                                                   | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                 |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate)                                                                                             | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster.                                                                                                                                                                                                                                |
| <a name="output_cluster_fqdn"></a> [cluster\_fqdn](#output\_cluster\_fqdn)                                                                                                                             | The FQDN of the Azure Kubernetes Managed Cluster.                                                                                                                                                                                                                                                                                                                                                                 |
| <a name="output_cluster_identity"></a> [cluster\_identity](#output\_cluster\_identity)                                                                                                                 | The `azurerm_kubernetes_cluster`'s `identity` block.                                                                                                                                                                                                                                                                                                                                                              |
| <a name="output_cluster_portal_fqdn"></a> [cluster\_portal\_fqdn](#output\_cluster\_portal\_fqdn)                                                                                                      | The FQDN for the Azure Portal resources when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster.                                                                                                                                                                                                                                                   |
| <a name="output_cluster_private_fqdn"></a> [cluster\_private\_fqdn](#output\_cluster\_private\_fqdn)                                                                                                   | The FQDN for the Kubernetes Cluster when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster.                                                                                                                                                                                                                                                       |
| <a name="output_generated_cluster_private_ssh_key"></a> [generated\_cluster\_private\_ssh\_key](#output\_generated\_cluster\_private\_ssh\_key)                                                        | The cluster will use this generated private key as ssh key when `var.public_ssh_key` is empty or null. Private key data in [PEM (RFC 1421)](https://datatracker.ietf.org/doc/html/rfc1421) format.                                                                                                                                                                                                                |
| <a name="output_generated_cluster_public_ssh_key"></a> [generated\_cluster\_public\_ssh\_key](#output\_generated\_cluster\_public\_ssh\_key)                                                           | The cluster will use this generated public key as ssh key when `var.public_ssh_key` is empty or null. The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. `aa:bb:cc:....` Only available if the selected private key format is compatible, similarly to `public_key_openssh` and the [ECDSA P224 limitations](https://registry.terraform.io/providers/hashicorp/tls/latest/docs#limitations). |
| <a name="output_host"></a> [host](#output\_host)                                                                                                                                                       | The `host` in the `azurerm_kubernetes_cluster`'s `kube_config` block. The Kubernetes cluster server host.                                                                                                                                                                                                                                                                                                         |
| <a name="output_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#output\_http\_application\_routing\_enabled)                                                             | The `azurerm_kubernetes_cluster`'s `http_application_routing_enabled` argument. (Optional) Should HTTP Application Routing be enabled?                                                                                                                                                                                                                                                                            |
| <a name="output_http_application_routing_zone_name"></a> [http\_application\_routing\_zone\_name](#output\_http\_application\_routing\_zone\_name)                                                     | The `azurerm_kubernetes_cluster`'s `http_application_routing_zone_name` argument. The Zone Name of the HTTP Application Routing.                                                                                                                                                                                                                                                                                  |
| <a name="output_ingress_application_gateway"></a> [ingress\_application\_gateway](#output\_ingress\_application\_gateway)                                                                              | The `azurerm_kubernetes_cluster`'s `ingress_application_gateway` block.                                                                                                                                                                                                                                                                                                                                           |
| <a name="output_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#output\_ingress\_application\_gateway\_enabled)                                                    | Has the `azurerm_kubernetes_cluster` turned on `ingress_application_gateway` block?                                                                                                                                                                                                                                                                                                                               |
| <a name="output_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#output\_key\_vault\_secrets\_provider)                                                                               | The `azurerm_kubernetes_cluster`'s `key_vault_secrets_provider` block.                                                                                                                                                                                                                                                                                                                                            |
| <a name="output_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#output\_key\_vault\_secrets\_provider\_enabled)                                                     | Has the `azurerm_kubernetes_cluster` turned on `key_vault_secrets_provider` block?                                                                                                                                                                                                                                                                                                                                |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw)                                                                                              | The `azurerm_kubernetes_cluster`'s `kube_admin_config_raw` argument. Raw Kubernetes config for the admin account to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled.                                                             |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw)                                                                                                                  | The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools.                                                                                                                                                                                                                  |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity)                                                                                                                 | The `azurerm_kubernetes_cluster`'s `kubelet_identity` block.                                                                                                                                                                                                                                                                                                                                                      |
| <a name="output_location"></a> [location](#output\_location)                                                                                                                                           | The `azurerm_kubernetes_cluster`'s `location` argument. (Required) The location where the Managed Kubernetes Cluster should be created.                                                                                                                                                                                                                                                                           |
| <a name="output_network_profile"></a> [network\_profile](#output\_network\_profile)                                                                                                                    | The `azurerm_kubernetes_cluster`'s `network_profile` block                                                                                                                                                                                                                                                                                                                                                        |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group)                                                                                                      | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster.                                                                                                                                                                                                                                                                                                               |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url)                                                                                                                  | The OIDC issuer URL that is associated with the cluster.                                                                                                                                                                                                                                                                                                                                                          |
| <a name="output_oms_agent"></a> [oms\_agent](#output\_oms\_agent)                                                                                                                                      | The `azurerm_kubernetes_cluster`'s `oms_agent` argument.                                                                                                                                                                                                                                                                                                                                                          |
| <a name="output_oms_agent_enabled"></a> [oms\_agent\_enabled](#output\_oms\_agent\_enabled)                                                                                                            | Has the `azurerm_kubernetes_cluster` turned on `oms_agent` block?                                                                                                                                                                                                                                                                                                                                                 |
| <a name="output_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#output\_open\_service\_mesh\_enabled)                                                                                  | (Optional) Is Open Service Mesh enabled? For more details, please visit [Open Service Mesh for AKS](https://docs.microsoft.com/azure/aks/open-service-mesh-about).                                                                                                                                                                                                                                                |
| <a name="output_password"></a> [password](#output\_password)                                                                                                                                           | The `password` in the `azurerm_kubernetes_cluster`'s `kube_config` block. A password or token used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                     |
| <a name="output_username"></a> [username](#output\_username)                                                                                                                                           | The `username` in the `azurerm_kubernetes_cluster`'s `kube_config` block. A username used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                              |
<!-- END_TF_DOCS -->
