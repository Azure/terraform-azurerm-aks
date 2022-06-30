# terraform-azurerm-aks
## Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

-> **NOTE:** If you have not assigned `client_id` or `client_secret`, A `SystemAssigned` identity will be created.

## Usage in Terraform 0.13

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "aks-resource-group"
  location = "eastus"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = "10.52.0.0/16"
  subnet_prefixes     = ["10.52.0.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.example]
}

data "azuread_group" "aks_cluster_admins" {
  display_name = "AKS-cluster-admins"
}

module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = azurerm_resource_group.example.name
  client_id                        = "your-service-principal-client-appid"
  client_secret                    = "your-service-principal-client-password"
  kubernetes_version               = "1.23.5"
  orchestrator_version             = "1.23.5"
  prefix                           = "prefix"
  cluster_name                     = "cluster-name"
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = 50
  sku_tier                         = "Paid" # defaults to Free
  enable_role_based_access_control = true
  rbac_aad_admin_group_object_ids  = [data.azuread_group.aks_cluster_admins.id]
  rbac_aad_managed                 = true
  private_cluster_enabled          = true # default value
  enable_http_application_routing  = true
  enable_azure_policy              = true
  enable_auto_scaling              = true
  enable_host_encryption           = true
  agents_min_count                 = 1
  agents_max_count                 = 2
  agents_count                     = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = 100
  agents_pool_name                 = "exnodepool"
  agents_availability_zones        = ["1", "2"]
  agents_type                      = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  enable_ingress_application_gateway      = true
  ingress_application_gateway_name        = "aks-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [module.network]
}
```

## Usage in Terraform 0.12

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "aks-resource-group"
  location = "eastus"
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  prefix              = "prefix"
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

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native (Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
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

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | ~> 3.3   |

## Providers

| Name                                                          | Version |
|---------------------------------------------------------------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.3  |
| <a name="provider_tls"></a> [tls](#provider\_tls)             | n/a     |

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

| Name                                                                                                                                                            | Description                                                                                                                                                                                                                                        | Type           | Default                     | Required |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-----------------------------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)                                                                                  | The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created.                                         | `string`       | `null`                      |    no    |
| <a name="input_agents_availability_zones"></a> [agents\_availability\_zones](#input\_agents\_availability\_zones)                                               | (Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created.                                                                                                            | `list(string)` | `null`                      |    no    |
| <a name="input_agents_count"></a> [agents\_count](#input\_agents\_count)                                                                                        | The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.                                                                         | `number`       | `2`                         |    no    |
| <a name="input_agents_labels"></a> [agents\_labels](#input\_agents\_labels)                                                                                     | (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created.                                                                                                | `map(string)`  | `{}`                        |    no    |
| <a name="input_agents_max_count"></a> [agents\_max\_count](#input\_agents\_max\_count)                                                                          | Maximum number of nodes in a pool                                                                                                                                                                                                                  | `number`       | `null`                      |    no    |
| <a name="input_agents_max_pods"></a> [agents\_max\_pods](#input\_agents\_max\_pods)                                                                             | (Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created.                                                                                                                               | `number`       | `null`                      |    no    |
| <a name="input_agents_min_count"></a> [agents\_min\_count](#input\_agents\_min\_count)                                                                          | Minimum number of nodes in a pool                                                                                                                                                                                                                  | `number`       | `null`                      |    no    |
| <a name="input_agents_pool_name"></a> [agents\_pool\_name](#input\_agents\_pool\_name)                                                                          | The default Azure AKS agentpool (nodepool) name.                                                                                                                                                                                                   | `string`       | `"nodepool"`                |    no    |
| <a name="input_agents_size"></a> [agents\_size](#input\_agents\_size)                                                                                           | The default virtual machine size for the Kubernetes agents                                                                                                                                                                                         | `string`       | `"Standard_D2s_v3"`         |    no    |
| <a name="input_agents_tags"></a> [agents\_tags](#input\_agents\_tags)                                                                                           | (Optional) A mapping of tags to assign to the Node Pool.                                                                                                                                                                                           | `map(string)`  | `{}`                        |    no    |
| <a name="input_agents_type"></a> [agents\_type](#input\_agents\_type)                                                                                           | (Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets.                                                                                    | `string`       | `"VirtualMachineScaleSets"` |    no    |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id)                                                                                                 | (Optional) The Client ID (appId) for the Service Principal used for the AKS deployment                                                                                                                                                             | `string`       | `""`                        |    no    |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret)                                                                                     | (Optional) The Client Secret (password) for the Service Principal used for the AKS deployment                                                                                                                                                      | `string`       | `""`                        |    no    |
| <a name="input_cluster_log_analytics_workspace_name"></a> [cluster\_log\_analytics\_workspace\_name](#input\_cluster\_log\_analytics\_workspace\_name)          | (Optional) The name of the Analytics workspace                                                                                                                                                                                                     | `string`       | `null`                      |    no    |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)                                                                                        | (Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns\_prefix if it is set)                                        | `string`       | `null`                      |    no    |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling)                                                                 | Enable node pool autoscaling                                                                                                                                                                                                                       | `bool`         | `false`                     |    no    |
| <a name="input_enable_azure_policy"></a> [enable\_azure\_policy](#input\_enable\_azure\_policy)                                                                 | Enable Azure Policy Addon.                                                                                                                                                                                                                         | `bool`         | `false`                     |    no    |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption)                                                        | Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli                                       | `bool`         | `false`                     |    no    |
| <a name="input_enable_http_application_routing"></a> [enable\_http\_application\_routing](#input\_enable\_http\_application\_routing)                           | Enable HTTP Application Routing Addon (forces recreation).                                                                                                                                                                                         | `bool`         | `false`                     |    no    |
| <a name="input_enable_ingress_application_gateway"></a> [enable\_ingress\_application\_gateway](#input\_enable\_ingress\_application\_gateway)                  | Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?                                                                                                                                                           | `bool`         | `false`                     |    no    |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace)                              | Enable the creation of azurerm\_log\_analytics\_workspace and azurerm\_log\_analytics\_solution or not                                                                                                                                             | `bool`         | `true`                      |    no    |
| <a name="input_enable_node_public_ip"></a> [enable\_node\_public\_ip](#input\_enable\_node\_public\_ip)                                                         | (Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false.                                                                                                                                                             | `bool`         | `false`                     |    no    |
| <a name="input_enable_role_based_access_control"></a> [enable\_role\_based\_access\_control](#input\_enable\_role\_based\_access\_control)                      | Enable Role Based Access Control.                                                                                                                                                                                                                  | `bool`         | `false`                     |    no    |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids)                                                                                        | (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster.                                                                                                                                       | `list(string)` | `null`                      |    no    |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type)                                                                                     | (Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well. | `string`       | `"SystemAssigned"`          |    no    |
| <a name="input_ingress_application_gateway_id"></a> [ingress\_application\_gateway\_id](#input\_ingress\_application\_gateway\_id)                              | The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster.                                                                                                                                             | `string`       | `null`                      |    no    |
| <a name="input_ingress_application_gateway_name"></a> [ingress\_application\_gateway\_name](#input\_ingress\_application\_gateway\_name)                        | The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                 | `string`       | `null`                      |    no    |
| <a name="input_ingress_application_gateway_subnet_cidr"></a> [ingress\_application\_gateway\_subnet\_cidr](#input\_ingress\_application\_gateway\_subnet\_cidr) | The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                                              | `string`       | `null`                      |    no    |
| <a name="input_ingress_application_gateway_subnet_id"></a> [ingress\_application\_gateway\_subnet\_id](#input\_ingress\_application\_gateway\_subnet\_id)       | The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster.                                                                                           | `string`       | `null`                      |    no    |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version)                                                                      | Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region                                                                                                                                 | `string`       | `null`                      |    no    |
| <a name="input_location"></a> [location](#input\_location)                                                                                                      | Location of cluster, if not defined it will be read from the resource-group                                                                                                                                                                        | `string`       | `null`                      |    no    |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku)                                       | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018                                                                                                                                   | `string`       | `"PerGB2018"`               |    no    |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days)                                                         | The retention period for the logs in days                                                                                                                                                                                                          | `number`       | `30`                        |    no    |
| <a name="input_net_profile_dns_service_ip"></a> [net\_profile\_dns\_service\_ip](#input\_net\_profile\_dns\_service\_ip)                                        | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created.                                                                    | `string`       | `null`                      |    no    |
| <a name="input_net_profile_docker_bridge_cidr"></a> [net\_profile\_docker\_bridge\_cidr](#input\_net\_profile\_docker\_bridge\_cidr)                            | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created.                                                                                                         | `string`       | `null`                      |    no    |
| <a name="input_net_profile_outbound_type"></a> [net\_profile\_outbound\_type](#input\_net\_profile\_outbound\_type)                                             | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer.                                                               | `string`       | `"loadBalancer"`            |    no    |
| <a name="input_net_profile_pod_cidr"></a> [net\_profile\_pod\_cidr](#input\_net\_profile\_pod\_cidr)                                                            | (Optional) The CIDR to use for pod IP addresses. This field can only be set when network\_plugin is set to kubenet. Changing this forces a new resource to be created.                                                                             | `string`       | `null`                      |    no    |
| <a name="input_net_profile_service_cidr"></a> [net\_profile\_service\_cidr](#input\_net\_profile\_service\_cidr)                                                | (Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created.                                                                                                                                    | `string`       | `null`                      |    no    |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin)                                                                                  | Network plugin to use for networking.                                                                                                                                                                                                              | `string`       | `"kubenet"`                 |    no    |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy)                                                                                  | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created.                | `string`       | `null`                      |    no    |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group)                                                                 | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. Changing this forces a new resource to be created.                                                                                             | `string`       | `null`                      |    no    |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled)                                                                 | Enable or Disable the OIDC issuer URL. Defaults to false.                                                                                                                                                                                          | `bool`         | `false`                     |    no    |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version)                                                                | Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region                                                                                                     | `string`       | `null`                      |    no    |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb)                                                                           | Disk size of nodes in GBs.                                                                                                                                                                                                                         | `number`       | `50`                        |    no    |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type)                                                                                      | The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. Changing this forces a new resource to be created.                                                           | `string`       | `"Managed"`                 |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                                            | (Required) The prefix for the resources created in the specified Azure Resource Group                                                                                                                                                              | `string`       | n/a                         |   yes    |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled)                                                     | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet.                                                                                                                                         | `bool`         | `false`                     |    no    |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key)                                                                                | A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created.                                                                                                                                          | `string`       | `""`                        |    no    |
| <a name="input_rbac_aad_admin_group_object_ids"></a> [rbac\_aad\_admin\_group\_object\_ids](#input\_rbac\_aad\_admin\_group\_object\_ids)                       | Object ID of groups with admin access.                                                                                                                                                                                                             | `list(string)` | `null`                      |    no    |
| <a name="input_rbac_aad_client_app_id"></a> [rbac\_aad\_client\_app\_id](#input\_rbac\_aad\_client\_app\_id)                                                    | The Client ID of an Azure Active Directory Application.                                                                                                                                                                                            | `string`       | `null`                      |    no    |
| <a name="input_rbac_aad_managed"></a> [rbac\_aad\_managed](#input\_rbac\_aad\_managed)                                                                          | Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration.                                                                                                               | `bool`         | `false`                     |    no    |
| <a name="input_rbac_aad_server_app_id"></a> [rbac\_aad\_server\_app\_id](#input\_rbac\_aad\_server\_app\_id)                                                    | The Server ID of an Azure Active Directory Application.                                                                                                                                                                                            | `string`       | `null`                      |    no    |
| <a name="input_rbac_aad_server_app_secret"></a> [rbac\_aad\_server\_app\_secret](#input\_rbac\_aad\_server\_app\_secret)                                        | The Server Secret of an Azure Active Directory Application.                                                                                                                                                                                        | `string`       | `null`                      |    no    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)                                                                 | The resource group name to be imported                                                                                                                                                                                                             | `string`       | n/a                         |   yes    |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier)                                                                                                    | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid                                                                                                                                                    | `string`       | `"Free"`                    |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                                  | Any tags that should be present on the AKS cluster resources                                                                                                                                                                                       | `map(string)`  | `{}`                        |    no    |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id)                                                                                | (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created.                                                                                                                      | `string`       | `null`                      |    no    |

## Outputs

| Name                                                                                                                                                | Description                                                                                            |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| <a name="output_aci_connector_linux"></a> [aci\_connector\_linux](#output\_aci\_connector\_linux)                                                   | n/a                                                                                                    |
| <a name="output_aci_connector_linux_enabled"></a> [aci\_connector\_linux\_enabled](#output\_aci\_connector\_linux\_enabled)                         | n/a                                                                                                    |
| <a name="output_admin_client_certificate"></a> [admin\_client\_certificate](#output\_admin\_client\_certificate)                                    | n/a                                                                                                    |
| <a name="output_admin_client_key"></a> [admin\_client\_key](#output\_admin\_client\_key)                                                            | n/a                                                                                                    |
| <a name="output_admin_cluster_ca_certificate"></a> [admin\_cluster\_ca\_certificate](#output\_admin\_cluster\_ca\_certificate)                      | n/a                                                                                                    |
| <a name="output_admin_host"></a> [admin\_host](#output\_admin\_host)                                                                                | n/a                                                                                                    |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password)                                                                    | n/a                                                                                                    |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username)                                                                    | n/a                                                                                                    |
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id)                                                                                            | n/a                                                                                                    |
| <a name="output_azure_policy_enabled"></a> [azure\_policy\_enabled](#output\_azure\_policy\_enabled)                                                | n/a                                                                                                    |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate)                                                        | n/a                                                                                                    |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key)                                                                                | n/a                                                                                                    |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate)                                          | n/a                                                                                                    |
| <a name="output_generated_cluster_private_ssh_key"></a> [generated\_cluster\_private\_ssh\_key](#output\_generated\_cluster\_private\_ssh\_key)     | The cluster will use this generated private key as ssh key when `var.public_ssh_key` is empty or null. |
| <a name="output_generated_cluster_public_ssh_key"></a> [generated\_cluster\_public\_ssh\_key](#output\_generated\_cluster\_public\_ssh\_key)        | The cluster will use this generated public key as ssh key when `var.public_ssh_key` is empty or null.  |
| <a name="output_host"></a> [host](#output\_host)                                                                                                    | n/a                                                                                                    |
| <a name="output_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#output\_http\_application\_routing\_enabled)          | n/a                                                                                                    |
| <a name="output_http_application_routing_zone_name"></a> [http\_application\_routing\_zone\_name](#output\_http\_application\_routing\_zone\_name)  | n/a                                                                                                    |
| <a name="output_ingress_application_gateway"></a> [ingress\_application\_gateway](#output\_ingress\_application\_gateway)                           | n/a                                                                                                    |
| <a name="output_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#output\_ingress\_application\_gateway\_enabled) | n/a                                                                                                    |
| <a name="output_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#output\_key\_vault\_secrets\_provider)                            | n/a                                                                                                    |
| <a name="output_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#output\_key\_vault\_secrets\_provider\_enabled)  | n/a                                                                                                    |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw)                                           | n/a                                                                                                    |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw)                                                               | n/a                                                                                                    |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity)                                                              | n/a                                                                                                    |
| <a name="output_location"></a> [location](#output\_location)                                                                                        | n/a                                                                                                    |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group)                                                   | n/a                                                                                                    |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url)                                                               | n/a                                                                                                    |
| <a name="output_oms_agent"></a> [oms\_agent](#output\_oms\_agent)                                                                                   | n/a                                                                                                    |
| <a name="output_oms_agent_enabled"></a> [oms\_agent\_enabled](#output\_oms\_agent\_enabled)                                                         | n/a                                                                                                    |
| <a name="output_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#output\_open\_service\_mesh\_enabled)                               | n/a                                                                                                    |
| <a name="output_password"></a> [password](#output\_password)                                                                                        | n/a                                                                                                    |
| <a name="output_system_assigned_identity"></a> [system\_assigned\_identity](#output\_system\_assigned\_identity)                                    | n/a                                                                                                    |
| <a name="output_username"></a> [username](#output\_username)                                                                                        | n/a                                                                                                    |
<!-- END_TF_DOCS -->