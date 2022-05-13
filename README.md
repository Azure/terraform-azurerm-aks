# terraform-azurerm-aks
## Deploys a Kubernetes cluster on AKS with optional monitoring through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

-> **NOTE:** If you have not assigned `client_id` or `client_secret`, A `SystemAssigned` identity will be created.

## Example usage in Terraform 1.0.0+
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
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.example]
}

data "azuread_group" "aks_cluster_admins" {
  name = "AKS-cluster-admins"
}

module "aks" {
  source                       = "Azure/aks/azurerm"
  prefix                       = "prefix-${random_id.prefix.hex}"
  resource_group_name          = azurerm_resource_group.example.name
  vnet_subnet_id               = module.network.vnet_subnets[0]
  sku_tier                     = "Paid"
  enable_auto_scaling          = true
  min_count                    = 1
  max_count                    = 2
  node_count                   = 1
  max_pods                     = 110
  depends_on                   = [module.network]

  node_labels = {
    "node1" = "label1"
  }

  node_tags = {
    "tag1" = "Tag1"
  }
}

output "module_aks_kube_config_raw" {
  value     = module.aks[*].kube_config_raw
  sensitive = true
}
```

The module supports some outputs that may be used to configure a kubernetes
provider after deploying an AKS cluster.

```hcl
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
}
```

## Test

### Configurations
- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0, < 4.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.3.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.0, < 4.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.3.0, < 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_log_analytics_solution.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.azure_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [tls_private_key.main](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name to be used for the AKS deployment. | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Optional) The username of the local administrator to be created on the AKS deployment. | `string` | `"azureadmin"` | no |
| <a name="input_allowed_maintenance_windows"></a> [allowed\_maintenance\_windows](#input\_allowed\_maintenance\_windows) | (Optional) List of allowed Maintenance Windows for AKS. | <pre>list(object({<br>    day   = string<br>    hours = list(number)<br>  }))</pre> | <pre>[<br>  {<br>    "day": "Saturday",<br>    "hours": [<br>      1<br>    ]<br>  },<br>  {<br>    "day": "Sunday",<br>    "hours": [<br>      1<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_azure_container_registry_enabled"></a> [azure\_container\_registry\_enabled](#input\_azure\_container\_registry\_enabled) | (Optional) Should the AKS deployment access a Container Registry? | `bool` | `false` | no |
| <a name="input_azure_container_registry_id"></a> [azure\_container\_registry\_id](#input\_azure\_container\_registry\_id) | (Optional) The ID of the Container Registry. | `string` | `null` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | (Optional) Should the Azure Policy Add-On be enabled? For more details please visit [Understand Azure Policy for Azure Kubernetes Service](https://docs.microsoft.com/en-ie/azure/governance/policy/concepts/rego-for-aks) | `bool` | `false` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | (Optional) The Client ID (appId) for the Service Principal used for the AKS deployment. | `string` | `null` | no |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | (Optional) The Client Secret (password) for the Service Principal used for the AKS deployment. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) The name for the AKS deployment. This variable overwrites the 'prefix' variable. | `string` | `null` | no |
| <a name="input_default_node_pool_name"></a> [default\_node\_pool\_name](#input\_default\_node\_pool\_name) | (Optional) The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created. | `string` | `"default"` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | (Optional) The DNS prefix for the AKS deployment. This is used to create a unique FQDN for the cluster when it is created. | `string` | `null` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_docker_bridge_cidr"></a> [docker\_bridge\_cidr](#input\_docker\_bridge\_cidr) | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | (Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption) | (Optional) Enable Host Encryption for default Node Pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli | `bool` | `false` | no |
| <a name="input_enable_node_public_ip"></a> [enable\_node\_public\_ip](#input\_enable\_node\_public\_ip) | (Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_role_based_access_control"></a> [enable\_role\_based\_access\_control](#input\_enable\_role\_based\_access\_control) | (Optional) Enables Role Based Access Control. | `bool` | `false` | no |
| <a name="input_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#input\_http\_application\_routing\_enabled) | (Optional) Should HTTP Application Routing be enabled? | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster. This is required when type is set to UserAssigned or SystemAssigned, UserAssigned. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"SystemAssigned"` | no |
| <a name="input_ingress_application_gateway_enabled"></a> [ingress\_application\_gateway\_enabled](#input\_ingress\_application\_gateway\_enabled) | (Optional) Integrates Application Gateway Ingress Controller to this Kubernetes Cluster. Requires an existing Application Gateway. | `bool` | `false` | no |
| <a name="input_ingress_application_gateway_id"></a> [ingress\_application\_gateway\_id](#input\_ingress\_application\_gateway\_id) | (Optional) The ID of the Application Gateway to integrate as Application Gateway Ingress Controller of this Kubernetes Cluster. | `string` | `null` | no |
| <a name="input_ingress_application_gateway_name"></a> [ingress\_application\_gateway\_name](#input\_ingress\_application\_gateway\_name) | (Optional) The name of the Application Gateway to be used or created in the Node Pool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. | `string` | `null` | no |
| <a name="input_ingress_application_gateway_subnet_cidr"></a> [ingress\_application\_gateway\_subnet\_cidr](#input\_ingress\_application\_gateway\_subnet\_cidr) | (Optional) The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. | `string` | `null` | no |
| <a name="input_ingress_application_gateway_subnet_id"></a> [ingress\_application\_gateway\_subnet\_id](#input\_ingress\_application\_gateway\_subnet\_id) | (Optional) The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. | `string` | `null` | no |
| <a name="input_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#input\_key\_vault\_secrets\_provider) | (Optional) A key\_vault\_secrets\_provider block. For more details, please visit [Azure Keyvault Secrets Provider for AKS](https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver). | <pre>list(object({<br>    secret_rotation_enabled  = bool<br>    secret_rotation_interval = string<br>  }))</pre> | <pre>[<br>  {<br>    "secret_rotation_enabled": true,<br>    "secret_rotation_interval": "2m"<br>  }<br>]</pre> | no |
| <a name="input_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#input\_key\_vault\_secrets\_provider\_enabled) | (Optional) Enables the Key Vault Secret provider. | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region. | `string` | `null` | no |
| <a name="input_log_analytics_solution_enabled"></a> [log\_analytics\_solution\_enabled](#input\_log\_analytics\_solution\_enabled) | (Optional) Enables the Log Analytics Solution for monitoring the Log Analytics Workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_enabled"></a> [log\_analytics\_workspace\_enabled](#input\_log\_analytics\_workspace\_enabled) | (Optional) Enable the creation of a Log Analytics Workspace. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | (Optional) If enabled, the name of the Log Analytics Workspace. | `string` | `null` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | (Optional) The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | (Optional) The retention period in days for logging in the Log Analytics Workspace. | `number` | `30` | no |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | (Optional) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | (Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created. | `number` | `110` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | (Optional) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | (Optional) Network plugin to use for networking. Currently supported values are azure and kubenet. Changing this forces a new resource to be created. | `string` | `"azure"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are 'calico' and 'azure'. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | (Optional) The number of nodes that should exist in the default Node Pool. This value is ignored when auto-scaling is enabled. | `number` | `2` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | (Optional) The name of the Resource Group where the Kubernetes Nodes should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_node_tags"></a> [node\_tags](#input\_node\_tags) | (Optional) A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | (Optional) A mapping of taints to assign to the Node Pool. | `list(string)` | `[]` | no |
| <a name="input_not_allowed_maintenance_windows"></a> [not\_allowed\_maintenance\_windows](#input\_not\_allowed\_maintenance\_windows) | (Optional) The start and end of a time span, formatted as an RFC3339 (2022-01-01T00:00:00Z) string. | <pre>list(object({<br>    start = string<br>    end   = string<br>  }))</pre> | `[]` | no |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version) | (Optional) Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region | `string` | `null` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | (Optional) The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | (Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_os_sku"></a> [os\_sku](#input\_os\_sku) | (Optional) SKU to be used to specify Linux OS. Not applicable to Windows. Possible values include: Ubuntu, CBLMariner. Defaults to Ubuntu. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer. | `string` | `"loadBalancer"` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | (Optional) The CIDR to use for pod IP addresses. This field can only be set when network\_plugin is set to kubenet. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Optional) The prefix for the resources created in the specified Azure Resource Group. | `string` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | (Optional) Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key) | (Optional) A custom SSH key to control access to the AKS deployment. | `string` | `null` | no |
| <a name="input_rbac_aad_admin_group_object_ids"></a> [rbac\_aad\_admin\_group\_object\_ids](#input\_rbac\_aad\_admin\_group\_object\_ids) | (Optional) List of Object IDs that are granted admin access. | `list(string)` | `null` | no |
| <a name="input_rbac_aad_client_app_id"></a> [rbac\_aad\_client\_app\_id](#input\_rbac\_aad\_client\_app\_id) | (Optional) The Client ID of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_rbac_aad_managed"></a> [rbac\_aad\_managed](#input\_rbac\_aad\_managed) | (Optional) If set to true, Azure will create/manage a Service Principal used for integration. | `bool` | `true` | no |
| <a name="input_rbac_aad_server_app_id"></a> [rbac\_aad\_server\_app\_id](#input\_rbac\_aad\_server\_app\_id) | (Optional) The Application ID of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_rbac_aad_server_app_secret"></a> [rbac\_aad\_server\_app\_secret](#input\_rbac\_aad\_server\_app\_secret) | (Optional) The Application Secret of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | (Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_service_principal_enabled"></a> [service\_principal\_enabled](#input\_service\_principal\_enabled) | (Optional) Should the Azure Policy Add-On be enabled? For more details please visit [Understand Azure Policy for Azure Kubernetes Service](https://docs.microsoft.com/en-ie/azure/governance/policy/concepts/rego-for-aks) | `bool` | `false` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are 'Free' and 'Paid'. | `string` | `"Free"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Optional) The size of the Virtual Machine, such as Standard\_DS2\_v2. The Microsoft-recommended default size for AKS nodes. | `string` | `"Standard_DS2_v2"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster should be located. Changing this forces a new Kubernetes Cluster to be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | The Kubernetes Managed Cluster ID. |
| <a name="output_http_application_routing_zone_name"></a> [http\_application\_routing\_zone\_name](#output\_http\_application\_routing\_zone\_name) | The Zone Name of the HTTP Application Routing. |
| <a name="output_identity"></a> [identity](#output\_identity) | The Principal and Tenant IDs associated with this Managed Service Identity. |
| <a name="output_kube_admin_config"></a> [kube\_admin\_config](#output\_kube\_admin\_config) | Map of credentials to authenticate to Kubernetes as an administrator. |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw) | Raw Kubernetes config for the admin account to be used by kubectl and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Map of credentials to authenticate to Kubernetes as a user. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw Kubernetes config to be used by kubectl and other compatible tools. |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | The Client, Object and User Assigned Identity IDs of the Managed Identity to be assigned to the Kubelets. |
| <a name="output_location"></a> [location](#output\_location) | The location where the Managed Kubernetes Cluster is created. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The Log Analytics Workspace ID. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | The name of the Resource Group where the Kubernetes Nodes should exist. |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | Private key data in PEM (RFC 1421) and OpenSSH PEM (RFC 4716) format. |
| <a name="output_public_key"></a> [public\_key](#output\_public\_key) | Public key data in PEM (RFC 1421) and [Authorized Keys](https://www.ssh.com/academy/ssh/authorized_keys/openssh#format-of-the-authorized-keys-file) format. |

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
