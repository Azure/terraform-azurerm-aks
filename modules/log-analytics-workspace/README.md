#  log-analytics-workspace

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| CLIENT\_ID | The Client ID (appId) for the Service Principal used for the AKS deployment | string | n/a | yes |
| CLIENT\_SECRET | The Client Secret (password) for the Service Principal used for the AKS deployment | string | n/a | yes |
| prefix | The prefix for the resources created in the specified Azure Resource Group | string | n/a | yes |
| admin\_username | The username of the local administrator to be created on the Kubernetes cluster | string | `"azureuser"` | no |
| agent\_pool\_profile | An agent_pool_profile block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#agent_pool_profile | list(any) | `[ { "agents_count": 2, "count": 1, "name": "nodepool", "os_disk_size_gb": 50, "os_type": "Linux", "vm_size": "standard_f2" } ]` | no |
| aks\_ignore\_changes | lifecycle.aks_ignore_changes to ignore | list(string) | `[ "" ]` | no |
| default\_node\_pool | A default_node_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#default_node_pool | map(any) | `{ "enable_auto_scaling": true, "name": "nodepool", "os_disk_size_gb": 50, "type": "VirtualMachineScaleSets", "vm_size": "standard_f2" }` | no |
| kubernetes\_version | Version of Kubernetes to install | string | `"1.14.5"` | no |
| location | The location for the AKS deployment | string | `"eastus"` | no |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018 | string | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | number | `"30"` | no |
| network\_profile | Variables defining the AKS network profile config | object | `{ "dns_service_ip": "", "docker_bridge_cidr": "", "network_plugin": "kubenet", "network_policy": "", "pod_cidr": "", "service_cidr": "" }` | no |
| public\_ssh\_key | A custom ssh key to control access to the AKS cluster | string | `""` | no |
| tags | Any tags that should be present on resources | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aks\_resource\_group | Resource Group object which AKS resides in |
| client\_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| client\_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| cluster\_ca\_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| host | The Kubernetes cluster server host. |
| kube\_config\_raw | Raw Kubernetes config to be used by kubectl and other compatible tools. |
| location | The location where the Managed Kubernetes Cluster was created. |
| node\_resource\_group | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. |
| password | A password or token used to authenticate to the Kubernetes cluster. |
| username | A username used to authenticate to the Kubernetes cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
