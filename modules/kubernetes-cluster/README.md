# kubernetes-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| admin\_public\_ssh\_key | The SSH key to be used for the username defined in the `admin_username` variable. | `any` | n/a | yes |
| admin\_username | The username of the local administrator to be created on the Kubernetes cluster | `any` | n/a | yes |
| agent\_pool\_profile | An agent\_pool\_profile block | `any` | n/a | yes |
| default\_node\_pool | An default\_node\_pool block | `any` | n/a | yes |
| default\_node\_pool\_availability\_zones | The default\_node\_pools AZs | `list(string)` | n/a | yes |
| default\_node\_pool\_node\_taints | The default\_node\_pools node taints | `list(string)` | n/a | yes |
| kubernetes\_version | Version of Kubernetes to install | `string` | `"1.11.3"` | no |
| location | The Azure Region in which to create the Virtual Network | `any` | n/a | yes |
| log\_analytics\_workspace\_id | The Log Analytics Workspace Id. | `any` | n/a | yes |
| network\_profile | Variables defining the AKS network profile config | <pre>object({<br>    network_plugin     = string<br>    network_policy     = string<br>    dns_service_ip     = string<br>    docker_bridge_cidr = string<br>    pod_cidr           = string<br>    service_cidr       = string<br>  })<br></pre> | n/a | yes |
| prefix | The prefix for the resources created in the specified Azure Resource Group. | `any` | n/a | yes |
| rbac\_enabled | Boolean to enable or disable role-based access control | `bool` | `true` | no |
| resource\_group\_name | The name of the Resource Group in which the Virtual Network | `any` | n/a | yes |
| service\_principal\_client\_id | The Client ID of the Service Principal assigned to Kubernetes | `any` | n/a | yes |
| service\_principal\_client\_secret | The Client Secret of the Service Principal assigned to Kubernetes | `any` | n/a | yes |
| tags | Any tags that should be present on the Virtual Network resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | n/a |
| client\_key | n/a |
| cluster\_ca\_certificate | n/a |
| cluster\_id | n/a |
| host | n/a |
| kube\_config\_raw | n/a |
| location | n/a |
| node\_resource\_group | n/a |
| password | n/a |
| raw\_kube\_config | n/a |
| username | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
