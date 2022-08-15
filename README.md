# terraform-azurerm-aks

## Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

-> **NOTE:** If you have not assigned `client_id` or `client_secret`, A `SystemAssigned` identity will be created.

## Notice on Upgrade to V5.x

V5.0.0 is a major version upgrade and a lot of breaking changes have been introduced. Extreme caution must be taken during the upgrade to avoid resource replacement and downtime by accident.

Running the `terraform plan` first to inspect the plan is strongly advised.

### Terraform and terraform-provider-azurerm version restrictions

Now Terraform core's lowest version is v1.2.0 and terraform-provider-azurerm's lowest version is v3.3.0.

### variable `user_assigned_identity_id` has been renamed.

variable `user_assigned_identity_id` has been renamed to `identity_ids` and it's type has been changed from `string` to `list(string)`.

### `addon_profile` in outputs is no longer available. 

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

### The following variables have been renamed from `enable_xxx` to `xxx_enabled`

* `enable_azure_policy` has been renamed to `azure_policy_enabled`
* `enable_http_application_routing` has been renamed to `http_application_routing_enabled`
* `enable_ingress_application_gateway` has been renamed to `ingress_application_gateway_enabled`
* `enable_log_analytics_workspace` has been renamed to `log_analytics_workspace_enabled`
* `enable_open_service_mesh` has been renamed to `open_service_mesh_enabled`
* `enable_role_based_access_control` has been renamed to `role_based_access_control_enabled`

### `nullable = true` has been added to the following variables so setting them to `null` explicitly will use the default value

* `log_analytics_workspace_enable`
* `os_disk_type`
* `private_cluster_enabled`
* `rbac_aad_managed`
* `rbac_aad_admin_group_object_ids`
* `network_policy`
* `enable_node_public_ip`

### `var.admin_username`'s default value has been removed

In v4.x `var.admin_username` has a default value `azureuser` and has been removed in V5.0.0. Since the `admin_username` argument in `linux_profile` block is a ForceNew argument, any value change to this argument will trigger a Kubernetes cluster replacement **SO THE EXTREME CAUTION MUST BE TAKEN**. The module's callers must set `var.admin_username` to `azureuser` explicitly if they didn't set it before.

### `module.ssh-key` has been removed

The file named `private_ssh_key` which contains the tls private key will be deleted since the `local_file` resource has been removed. Now the private key is exported via `generated_cluster_private_ssh_key` in output and the corresponding public key is exported via `generated_cluster_public_ssh_key` in output.

A `moved` block has been added to relocate the existing `tls_private_key` resource to the new address. If the `var.admin_username` is not `null`, no action is needed.

Resource `tls_private_key`'s creation now is conditional. Users may see the destruction of existing `tls_private_key` in the generated plan if `var.admin_username` is `null`.

### `system_assigned_identity` in the output has been renamed to `cluster_identity`

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

### The following outputs are now sensitive. All outputs referenced them must be declared as sensitive too

* `client_certificate`
* `client_key`
* `cluster_ca_certificate`
* `generated_cluster_private_ssh_key`
* `host`
* `kube_admin_config_raw`
* `kube_config_raw`
* `password`
* `username`

## Usage in Terraform 1.2.0

```hcl
provider "azurerm" {
  features {}
}

resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "${random_id.prefix.hex}-rg"
}

resource "azurerm_virtual_network" "test" {
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.52.0.0/16"]
  location            = azurerm_resource_group.main.location
}

resource "azurerm_subnet" "test" {
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.52.0.0/24"]
}

resource "azurerm_user_assigned_identity" "test" {
  name                = "${random_id.prefix.hex}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

module "aks" {
  source = "../.."

  prefix                    = "prefix-${random_id.prefix.hex}"
  resource_group_name       = azurerm_resource_group.main.name
  agents_availability_zones = ["1", "2"]
  agents_count              = null
  agents_labels = {
    "node1" : "label1"
  }
  agents_max_count = 2
  agents_max_pods  = 100
  agents_min_count = 1
  agents_pool_name = "testnodepool"
  agents_tags = {
    "Agent" : "agentTag"
  }
  agents_type                             = "VirtualMachineScaleSets"
  azure_policy_enabled                    = true
  client_id                               = var.client_id
  client_secret                           = var.client_secret
  enable_auto_scaling                     = true
  enable_host_encryption                  = true
  http_application_routing_enabled        = true
  ingress_application_gateway_enabled     = true
  log_analytics_workspace_enabled         = true
  role_based_access_control_enabled       = true
  ingress_application_gateway_name        = "${random_id.prefix.hex}-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"
  local_account_disabled                  = true
  net_profile_dns_service_ip              = "10.0.0.10"
  net_profile_docker_bridge_cidr          = "170.10.0.1/16"
  net_profile_service_cidr                = "10.0.0.0/16"
  network_plugin                          = "azure"
  network_policy                          = "azure"
  os_disk_size_gb                         = 60
  private_cluster_enabled                 = true
  rbac_aad_managed                        = true
  sku_tier                                = "Paid"
  vnet_subnet_id                          = azurerm_subnet.test.id

  depends_on = [azurerm_resource_group.main]
}

module "aks_without_monitor" {
  source = "../.."

  prefix                            = "prefix2-${random_id.prefix.hex}"
  resource_group_name               = azurerm_resource_group.main.name
  azure_policy_enabled              = true
  log_analytics_workspace_enabled   = true
  role_based_access_control_enabled = true
  local_account_disabled            = true
  net_profile_pod_cidr              = "10.1.0.0/16"
  private_cluster_enabled           = true
  rbac_aad_managed                  = true

  depends_on = [azurerm_resource_group.main]
}

module "aks_cluster_name" {
  source = "../.."

  prefix              = "prefix"
  resource_group_name = azurerm_resource_group.main.name
  # Not necessary, just for demo purpose.
  admin_username                       = "azureuser"
  azure_policy_enabled                 = true
  cluster_log_analytics_workspace_name = "test-cluster"
  cluster_name                         = "test-cluster"
  log_analytics_workspace_enabled      = true
  role_based_access_control_enabled    = true
  identity_ids                         = [azurerm_user_assigned_identity.test.id]
  identity_type                        = "UserAssigned"
  local_account_disabled               = true
  net_profile_pod_cidr                 = "10.1.0.0/16"
  private_cluster_enabled              = true
  rbac_aad_managed                     = true

  depends_on = [azurerm_resource_group.main]
}
```

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

To try the module, please run `terraform apply` command in `test/fixture` folder.

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native (Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(>= 1.2.0)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install

# set service principal
$ export ARM_CLIENT_ID="service-principal-client-id"
$ export ARM_CLIENT_SECRET="service-principal-client-secret"
$ export ARM_SUBSCRIPTION_ID="subscription-id"
$ export ARM_TENANT_ID="tenant-id"
$ export ARM_TEST_LOCATION="eastus"
$ export ARM_TEST_LOCATION_ALT="eastus2"
$ export ARM_TEST_LOCATION_ALT2="westus"

# set aks variables
$ export TF_VAR_client_id="service-principal-client-id"
$ export TF_VAR_client_secret="service-principal-client-secret"

# run test
$ rake build
$ rake full
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `mcr.microsoft.com/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-aks .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake full"
```


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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | ~> 3.3  |
| <a name="requirement_tls"></a> [tls](#requirement\_tls)                   | >= 3.1  |

## Providers

| Name                                                          | Version |
|---------------------------------------------------------------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.18.0  |
| <a name="provider_tls"></a> [tls](#provider\_tls)             | 4.0.1   |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type        |
|-------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)           | resource    |
| [azurerm_log_analytics_solution.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution)   | resource    |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource    |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)                                  | resource    |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)                | data source |

## Inputs

| Name                                                                                                                                                                          | Description                                                                                                                                                                                                                                                                                                                      | Type                                                                  | Default                     | Required |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|-----------------------------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)                                                                                                | The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created.                                                                                                                       | `string`                                                              | `null`                      |    no    |
| <a name="input_agents_availability_zones"></a> [agents\_availability\_zones](#input\_agents\_availability\_zones)                                                             | (Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created.                                                                                                                                                                                          | `list(string)`                                                        | `null`                      |    no    |
| <a name="input_agents_count"></a> [agents\_count](#input\_agents\_count)                                                                                                      | The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.                                                                                                                                                       | `number`                                                              | `2`                         |    no    |
| <a name="input_agents_labels"></a> [agents\_labels](#input\_agents\_labels)                                                                                                   | (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created.                                                                                                                                                                              | `map(string)`                                                         | `{}`                        |    no    |
| <a name="input_agents_max_count"></a> [agents\_max\_count](#input\_agents\_max\_count)                                                                                        | Maximum number of nodes in a pool                                                                                                                                                                                                                                                                                                | `number`                                                              | `null`                      |    no    |
| <a name="input_agents_max_pods"></a> [agents\_max\_pods](#input\_agents\_max\_pods)                                                                                           | (Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created.                                                                                                                                                                                                             | `number`                                                              | `null`                      |    no    |
| <a name="input_agents_min_count"></a> [agents\_min\_count](#input\_agents\_min\_count)                                                                                        | Minimum number of nodes in a pool                                                                                                                                                                                                                                                                                                | `number`                                                              | `null`                      |    no    |
| <a name="input_agents_pool_name"></a> [agents\_pool\_name](#input\_agents\_pool\_name)                                                                                        | The default Azure AKS agentpool (nodepool) name.                                                                                                                                                                                                                                                                                 | `string`                                                              | `"nodepool"`                |    no    |
| <a name="input_agents_size"></a> [agents\_size](#input\_agents\_size)                                                                                                         | The default virtual machine size for the Kubernetes agents                                                                                                                                                                                                                                                                       | `string`                                                              | `"Standard_D2s_v3"`         |    no    |
| <a name="input_agents_tags"></a> [agents\_tags](#input\_agents\_tags)                                                                                                         | (Optional) A mapping of tags to assign to the Node Pool.                                                                                                                                                                                                                                                                         | `map(string)`                                                         | `{}`                        |    no    |
| <a name="input_agents_type"></a> [agents\_type](#input\_agents\_type)                                                                                                         | (Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets.                                                                                                                                                                  | `string`                                                              | `"VirtualMachineScaleSets"` |    no    |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges)                                       | (Optional) The IP ranges to allow for incoming traffic to the server nodes.                                                                                                                                                                                                                                                      | `set(string)`                                                         | `null`                      |    no    |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled)                                                                            | Enable Azure Policy Addon.                                                                                                                                                                                                                                                                                                       | `bool`                                                                | `false`                     |    no    |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id)                                                                                                               | (Optional) The Client ID (appId) for the Service Principal used for the AKS deployment                                                                                                                                                                                                                                           | `string`                                                              | `""`                        |    no    |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret)                                                                                                   | (Optional) The Client Secret (password) for the Service Principal used for the AKS deployment                                                                                                                                                                                                                                    | `string`                                                              | `""`                        |    no    |
| <a name="input_cluster_log_analytics_workspace_name"></a> [cluster\_log\_analytics\_workspace\_name](#input\_cluster\_log\_analytics\_workspace\_name)                        | (Optional) The name of the Analytics workspace                                                                                                                                                                                                                                                                                   | `string`                                                              | `null`                      |    no    |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)                                                                                                      | (Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns\_prefix if it is set)                                                                                                                      | `string`                                                              | `null`                      |    no    |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id)                                                                    | (Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes. More information [can be found in the documentation](https://docs.microsoft.com/azure/aks/azure-disk-customer-managed-keys). Changing this forces a new resource to be created.                                                     | `string`                                                              | `null`                      |    no    |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling)                                                                               | Enable node pool autoscaling                                                                                                                                                                                                                                                                                                     | `bool`                                                                | `false`                     |    no    |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption)                                                                      | Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli                                                                                                                     | `bool`                                                                | `false`                     |    no    |
| <a name="input_enable_node_public_ip"></a> [enable\_node\_public\_ip](#input\_enable\_node\_public\_ip)                                                                       | (Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false.                                                                                                                                                                                                                                           | `bool`                                                                | `false`                     |    no    |
| <a name="input_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#input\_http\_application\_routing\_enabled)                                      | Enable HTTP Application Routing Addon (forces recreation).                                                                                                                                                                                                                                                                       | `bool`                                                                | `false`                     |    no    |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids)                                                                                                      | (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster.                                                                                                                                                                                                                     | `list(string)`                                                        | `null`                      |    no    |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type)                                                                                                   | (Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`(to enable both). If `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well.            | `string`                                                              | `"SystemAssigned"`          |    no    |
| <a name="input_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#input\_ingress\_application\_gateway\_enabled)                             | Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?                                                                                                                                                                                                                                         | `bool`                                                                | `false`                     |    no    |
| <a name="input_ingress_application_gateway_id"></a> [ingress\_application\_gateway\_id](#input\_ingress\_application\_gateway\_id)                                            | The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster.                                                                                                                                                                                                                           | `string`                                                              | `null`                      |    no    |
| <a name="input_ingress_application_gateway_name"></a> [ingress\_application\_gateway\_name](#input\_ingress\_application\_gateway\_name)                                      | The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                                                                                               | `string`                                                              | `null`                      |    no    |
| <a name="input_ingress_application_gateway_subnet_cidr"></a> [ingress\_application\_gateway\_subnet\_cidr](#input\_ingress\_application\_gateway\_subnet\_cidr)               | The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                                                                                                                            | `string`                                                              | `null`                      |    no    |
| <a name="input_ingress_application_gateway_subnet_id"></a> [ingress\_application\_gateway\_subnet\_id](#input\_ingress\_application\_gateway\_subnet\_id)                     | The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                                                                                                                         | `string`                                                              | `null`                      |    no    |
| <a name="input_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#input\_key\_vault\_secrets\_provider\_enabled)                              | (Optional) Whether to use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster. For more details: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver                                                                                                                                     | `bool`                                                                | `false`                     |    no    |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version)                                                                                    | Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region                                                                                                                                                                                                               | `string`                                                              | `null`                      |    no    |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled)                                                                      | (Optional) - If `true` local accounts will be disabled. Defaults to `false`. See [the documentation](https://docs.microsoft.com/azure/aks/managed-aad#disable-local-accounts) for more information.                                                                                                                              | `bool`                                                                | `null`                      |    no    |
| <a name="input_location"></a> [location](#input\_location)                                                                                                                    | Location of cluster, if not defined it will be read from the resource-group                                                                                                                                                                                                                                                      | `string`                                                              | `null`                      |    no    |
| <a name="input_log_analytics_solution_id"></a> [log\_analytics\_solution\_id](#input\_log\_analytics\_solution\_id)                                                           | (Optional) Existing azurerm\_log\_analytics\_solution ID. Providing ID disables creation of azurerm\_log\_analytics\_solution.                                                                                                                                                                                                   | `string`                                                              | `null`                      |    no    |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace)                                                                   | (Optional) Existing azurerm\_log\_analytics\_workspace to attach azurerm\_log\_analytics\_solution. Providing the config disables creation of azurerm\_log\_analytics\_workspace.                                                                                                                                                | <pre>object({<br>    id   = string<br>    name = string<br>  })</pre> | `null`                      |    no    |
| <a name="input_log_analytics_workspace_enabled"></a> [log\_analytics\_workspace\_enabled](#input\_log\_analytics\_workspace\_enabled)                                         | Enable the integration of azurerm\_log\_analytics\_workspace and azurerm\_log\_analytics\_solution: https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-onboard                                                                                                                                   | `bool`                                                                | `true`                      |    no    |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | (Optional) Resource group name to create azurerm\_log\_analytics\_solution.                                                                                                                                                                                                                                                      | `string`                                                              | `null`                      |    no    |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku)                                                     | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018                                                                                                                                                                                                                 | `string`                                                              | `"PerGB2018"`               |    no    |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days)                                                                       | The retention period for the logs in days                                                                                                                                                                                                                                                                                        | `number`                                                              | `30`                        |    no    |
| <a name="input_net_profile_dns_service_ip"></a> [net\_profile\_dns\_service\_ip](#input\_net\_profile\_dns\_service\_ip)                                                      | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created.                                                                                                                                                  | `string`                                                              | `null`                      |    no    |
| <a name="input_net_profile_docker_bridge_cidr"></a> [net\_profile\_docker\_bridge\_cidr](#input\_net\_profile\_docker\_bridge\_cidr)                                          | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created.                                                                                                                                                                                       | `string`                                                              | `null`                      |    no    |
| <a name="input_net_profile_outbound_type"></a> [net\_profile\_outbound\_type](#input\_net\_profile\_outbound\_type)                                                           | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer.                                                                                                                                             | `string`                                                              | `"loadBalancer"`            |    no    |
| <a name="input_net_profile_pod_cidr"></a> [net\_profile\_pod\_cidr](#input\_net\_profile\_pod\_cidr)                                                                          | (Optional) The CIDR to use for pod IP addresses. This field can only be set when network\_plugin is set to kubenet. Changing this forces a new resource to be created.                                                                                                                                                           | `string`                                                              | `null`                      |    no    |
| <a name="input_net_profile_service_cidr"></a> [net\_profile\_service\_cidr](#input\_net\_profile\_service\_cidr)                                                              | (Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created.                                                                                                                                                                                                                  | `string`                                                              | `null`                      |    no    |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin)                                                                                                | Network plugin to use for networking.                                                                                                                                                                                                                                                                                            | `string`                                                              | `"kubenet"`                 |    no    |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy)                                                                                                | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created.                                                                                              | `string`                                                              | `null`                      |    no    |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group)                                                                               | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. Changing this forces a new resource to be created.                                                                                                                                                                           | `string`                                                              | `null`                      |    no    |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled)                                                                               | Enable or Disable the OIDC issuer URL. Defaults to false.                                                                                                                                                                                                                                                                        | `bool`                                                                | `false`                     |    no    |
| <a name="input_only_critical_addons_enabled"></a> [only\_critical\_addons\_enabled](#input\_only\_critical\_addons\_enabled)                                                  | (Optional) Enabling this option will taint default node pool with `CriticalAddonsOnly=true:NoSchedule` taint. Changing this forces a new resource to be created.                                                                                                                                                                 | `bool`                                                                | `null`                      |    no    |
| <a name="input_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#input\_open\_service\_mesh\_enabled)                                                           | Is Open Service Mesh enabled? For more details, please visit [Open Service Mesh for AKS](https://docs.microsoft.com/azure/aks/open-service-mesh-about).                                                                                                                                                                          | `bool`                                                                | `null`                      |    no    |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version)                                                                              | Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region                                                                                                                                                                                   | `string`                                                              | `null`                      |    no    |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb)                                                                                         | Disk size of nodes in GBs.                                                                                                                                                                                                                                                                                                       | `number`                                                              | `50`                        |    no    |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type)                                                                                                    | The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. Changing this forces a new resource to be created.                                                                                                                                         | `string`                                                              | `"Managed"`                 |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                                                          | (Required) The prefix for the resources created in the specified Azure Resource Group                                                                                                                                                                                                                                            | `string`                                                              | n/a                         |   yes    |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled)                                                                   | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet.                                                                                                                                                                                                                       | `bool`                                                                | `false`                     |    no    |
| <a name="input_private_cluster_public_fqdn_enabled"></a> [private\_cluster\_public\_fqdn\_enabled](#input\_private\_cluster\_public\_fqdn\_enabled)                           | (Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to `false`.                                                                                                                                                                                                                        | `bool`                                                                | `false`                     |    no    |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id)                                                                             | (Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, `System` to have AKS manage this or `None`. In case of `None` you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created. | `string`                                                              | `null`                      |    no    |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key)                                                                                              | A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created.                                                                                                                                                                                                                        | `string`                                                              | `""`                        |    no    |
| <a name="input_rbac_aad_admin_group_object_ids"></a> [rbac\_aad\_admin\_group\_object\_ids](#input\_rbac\_aad\_admin\_group\_object\_ids)                                     | Object ID of groups with admin access.                                                                                                                                                                                                                                                                                           | `list(string)`                                                        | `null`                      |    no    |
| <a name="input_rbac_aad_azure_rbac_enabled"></a> [rbac\_aad\_azure\_rbac\_enabled](#input\_rbac\_aad\_azure\_rbac\_enabled)                                                   | (Optional) Is Role Based Access Control based on Azure AD enabled?                                                                                                                                                                                                                                                               | `bool`                                                                | `null`                      |    no    |
| <a name="input_rbac_aad_client_app_id"></a> [rbac\_aad\_client\_app\_id](#input\_rbac\_aad\_client\_app\_id)                                                                  | The Client ID of an Azure Active Directory Application.                                                                                                                                                                                                                                                                          | `string`                                                              | `null`                      |    no    |
| <a name="input_rbac_aad_managed"></a> [rbac\_aad\_managed](#input\_rbac\_aad\_managed)                                                                                        | Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration.                                                                                                                                                                                             | `bool`                                                                | `false`                     |    no    |
| <a name="input_rbac_aad_server_app_id"></a> [rbac\_aad\_server\_app\_id](#input\_rbac\_aad\_server\_app\_id)                                                                  | The Server ID of an Azure Active Directory Application.                                                                                                                                                                                                                                                                          | `string`                                                              | `null`                      |    no    |
| <a name="input_rbac_aad_server_app_secret"></a> [rbac\_aad\_server\_app\_secret](#input\_rbac\_aad\_server\_app\_secret)                                                      | The Server Secret of an Azure Active Directory Application.                                                                                                                                                                                                                                                                      | `string`                                                              | `null`                      |    no    |
| <a name="input_rbac_aad_tenant_id"></a> [rbac\_aad\_tenant\_id](#input\_rbac\_aad\_tenant\_id)                                                                                | (Optional) The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used.                                                                                                                                                                                 | `string`                                                              | `null`                      |    no    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)                                                                               | The resource group name to be imported                                                                                                                                                                                                                                                                                           | `string`                                                              | n/a                         |   yes    |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled)                                 | Enable Role Based Access Control.                                                                                                                                                                                                                                                                                                | `bool`                                                                | `false`                     |    no    |
| <a name="input_secret_rotation_enabled"></a> [secret\_rotation\_enabled](#input\_secret\_rotation\_enabled)                                                                   | Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true` and defaults to `false`                                                                                                                                                                                               | `bool`                                                                | `false`                     |    no    |
| <a name="input_secret_rotation_interval"></a> [secret\_rotation\_interval](#input\_secret\_rotation\_interval)                                                                | The interval to poll for secret rotation. This attribute is only set when `secret_rotation` is `true` and defaults to `2m`                                                                                                                                                                                                       | `string`                                                              | `"2m"`                      |    no    |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier)                                                                                                                  | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid                                                                                                                                                                                                                                  | `string`                                                              | `"Free"`                    |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                                                | Any tags that should be present on the AKS cluster resources                                                                                                                                                                                                                                                                     | `map(string)`                                                         | `{}`                        |    no    |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id)                                                                                              | (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created.                                                                                                                                                                                                    | `string`                                                              | `null`                      |    no    |

## Outputs

| Name                                                                                                                                                | Description                                                                                                                                                                                                                                                                                                                                                                                                       |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a name="output_aci_connector_linux"></a> [aci\_connector\_linux](#output\_aci\_connector\_linux)                                                   | The `aci_connector_linux` block of `azurerm_kubernetes_cluster` resource.                                                                                                                                                                                                                                                                                                                                         |
| <a name="output_aci_connector_linux_enabled"></a> [aci\_connector\_linux\_enabled](#output\_aci\_connector\_linux\_enabled)                         | Has `aci_connector_linux` been enabled on the `azurerm_kubernetes_cluster` resource?                                                                                                                                                                                                                                                                                                                              |
| <a name="output_admin_client_certificate"></a> [admin\_client\_certificate](#output\_admin\_client\_certificate)                                    | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block.  Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                           |
| <a name="output_admin_client_key"></a> [admin\_client\_key](#output\_admin\_client\_key)                                                            | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                           |
| <a name="output_admin_cluster_ca_certificate"></a> [admin\_cluster\_ca\_certificate](#output\_admin\_cluster\_ca\_certificate)                      | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster.                                                                                                                                                                                                                          |
| <a name="output_admin_host"></a> [admin\_host](#output\_admin\_host)                                                                                | The `host` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. The Kubernetes cluster server host.                                                                                                                                                                                                                                                                                                   |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password)                                                                    | The `password` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. A password or token used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                               |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username)                                                                    | The `username` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. A username used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                        |
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id)                                                                                            | The `azurerm_kubernetes_cluster`'s id.                                                                                                                                                                                                                                                                                                                                                                            |
| <a name="output_azure_policy_enabled"></a> [azure\_policy\_enabled](#output\_azure\_policy\_enabled)                                                | The `azurerm_kubernetes_cluster`'s `azure_policy_enabled` argument. Should the Azure Policy Add-On be enabled? For more details please visit [Understand Azure Policy for Azure Kubernetes Service](https://docs.microsoft.com/en-ie/azure/governance/policy/concepts/rego-for-aks)                                                                                                                               |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate)                                                        | The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                  |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key)                                                                                | The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                 |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate)                                          | The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster.                                                                                                                                                                                                                                |
| <a name="output_cluster_identity"></a> [cluster\_identity](#output\_cluster\_identity)                                                              | The `azurerm_kubernetes_cluster`'s `identity` block.                                                                                                                                                                                                                                                                                                                                                              |
| <a name="output_generated_cluster_private_ssh_key"></a> [generated\_cluster\_private\_ssh\_key](#output\_generated\_cluster\_private\_ssh\_key)     | The cluster will use this generated private key as ssh key when `var.public_ssh_key` is empty or null. Private key data in [PEM (RFC 1421)](https://datatracker.ietf.org/doc/html/rfc1421) format.                                                                                                                                                                                                                |
| <a name="output_generated_cluster_public_ssh_key"></a> [generated\_cluster\_public\_ssh\_key](#output\_generated\_cluster\_public\_ssh\_key)        | The cluster will use this generated public key as ssh key when `var.public_ssh_key` is empty or null. The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. `aa:bb:cc:....` Only available if the selected private key format is compatible, similarly to `public_key_openssh` and the [ECDSA P224 limitations](https://registry.terraform.io/providers/hashicorp/tls/latest/docs#limitations). |
| <a name="output_host"></a> [host](#output\_host)                                                                                                    | The `host` in the `azurerm_kubernetes_cluster`'s `kube_config` block. The Kubernetes cluster server host.                                                                                                                                                                                                                                                                                                         |
| <a name="output_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#output\_http\_application\_routing\_enabled)          | The `azurerm_kubernetes_cluster`'s `http_application_routing_enabled` argument. (Optional) Should HTTP Application Routing be enabled?                                                                                                                                                                                                                                                                            |
| <a name="output_http_application_routing_zone_name"></a> [http\_application\_routing\_zone\_name](#output\_http\_application\_routing\_zone\_name)  | The `azurerm_kubernetes_cluster`'s `http_application_routing_zone_name` argument. The Zone Name of the HTTP Application Routing.                                                                                                                                                                                                                                                                                  |
| <a name="output_ingress_application_gateway"></a> [ingress\_application\_gateway](#output\_ingress\_application\_gateway)                           | The `azurerm_kubernetes_cluster`'s `ingress_application_gateway` block.                                                                                                                                                                                                                                                                                                                                           |
| <a name="output_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#output\_ingress\_application\_gateway\_enabled) | Has the `azurerm_kubernetes_cluster` turned on `ingress_application_gateway` block?                                                                                                                                                                                                                                                                                                                               |
| <a name="output_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#output\_key\_vault\_secrets\_provider)                            | The `azurerm_kubernetes_cluster`'s `key_vault_secrets_provider` block.                                                                                                                                                                                                                                                                                                                                            |
| <a name="output_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#output\_key\_vault\_secrets\_provider\_enabled)  | Has the `azurerm_kubernetes_cluster` turned on `key_vault_secrets_provider` block?                                                                                                                                                                                                                                                                                                                                |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw)                                           | The `azurerm_kubernetes_cluster`'s `kube_admin_config_raw` argument. Raw Kubernetes config for the admin account to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled.                                                             |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw)                                                               | The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools.                                                                                                                                                                                                                  |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity)                                                              | The `azurerm_kubernetes_cluster`'s `kubelet_identity` block.                                                                                                                                                                                                                                                                                                                                                      |
| <a name="output_location"></a> [location](#output\_location)                                                                                        | The `azurerm_kubernetes_cluster`'s `location` argument. (Required) The location where the Managed Kubernetes Cluster should be created.                                                                                                                                                                                                                                                                           |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group)                                                   | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster.                                                                                                                                                                                                                                                                                                               |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url)                                                               | The OIDC issuer URL that is associated with the cluster.                                                                                                                                                                                                                                                                                                                                                          |
| <a name="output_oms_agent"></a> [oms\_agent](#output\_oms\_agent)                                                                                   | The `azurerm_kubernetes_cluster`'s `oms_agent` argument.                                                                                                                                                                                                                                                                                                                                                          |
| <a name="output_oms_agent_enabled"></a> [oms\_agent\_enabled](#output\_oms\_agent\_enabled)                                                         | Has the `azurerm_kubernetes_cluster` turned on `oms_agent` block?                                                                                                                                                                                                                                                                                                                                                 |
| <a name="output_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#output\_open\_service\_mesh\_enabled)                               | (Optional) Is Open Service Mesh enabled? For more details, please visit [Open Service Mesh for AKS](https://docs.microsoft.com/azure/aks/open-service-mesh-about).                                                                                                                                                                                                                                                |
| <a name="output_password"></a> [password](#output\_password)                                                                                        | The `password` in the `azurerm_kubernetes_cluster`'s `kube_config` block. A password or token used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                     |
| <a name="output_username"></a> [username](#output\_username)                                                                                        | The `username` in the `azurerm_kubernetes_cluster`'s `kube_config` block. A username used to authenticate to the Kubernetes cluster.                                                                                                                                                                                                                                                                              |
<!-- END_TF_DOCS -->
