# terraform-azurerm-aks
Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| CLIENT\_ID | The Client ID (appId) for the Service Principal used for the AKS deployment | `string` | n/a | yes |
| CLIENT\_SECRET | The Client Secret (password) for the Service Principal used for the AKS deployment | `string` | n/a | yes |
| admin\_username | The username of the local administrator to be created on the Kubernetes cluster | `string` | `"azureuser"` | no |
| agent\_pool\_profile | An agent\_pool\_profile block, see terraform.io/docs/providers/azurerm/r/kubernetes\_cluster.html#agent\_pool\_profile | `list(any)` | <pre>[<br>  {<br>    "agents_count": 2,<br>    "count": 1,<br>    "name": "nodepool",<br>    "os_disk_size_gb": 50,<br>    "os_type": "Linux",<br>    "vm_size": "standard_f2"<br>  }<br>]<br></pre> | no |
| default\_node\_pool | A default\_node\_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes\_cluster.html#default\_node\_pool | `map(any)` | <pre>{<br>  "enable_auto_scaling": true,<br>  "name": "nodepool",<br>  "os_disk_size_gb": 50,<br>  "type": "VirtualMachineScaleSets",<br>  "vm_size": "standard_f2"<br>}<br></pre> | no |
| default\_node\_pool\_availability\_zones | The default\_node\_pools AZs | `list(string)` | n/a | yes |
| default\_node\_pool\_node\_taints | The default\_node\_pools node taints | `list(string)` | n/a | yes |
| kubernetes\_version | Version of Kubernetes to install | `string` | `"1.14.5"` | no |
| location | The location for the AKS deployment | `string` | `"eastus"` | no |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| network\_profile | Variables defining the AKS network profile config | <pre>object({<br>    network_plugin     = string<br>    network_policy     = string<br>    dns_service_ip     = string<br>    docker_bridge_cidr = string<br>    pod_cidr           = string<br>    service_cidr       = string<br>    load_balancer_sku  = string<br>  })<br></pre> | <pre>{<br>  "dns_service_ip": "",<br>  "docker_bridge_cidr": "",<br>  "load_balancer_sku": "Basic",<br>  "network_plugin": "kubenet",<br>  "network_policy": "",<br>  "pod_cidr": "",<br>  "service_cidr": ""<br>}<br></pre> | no |
| prefix | The prefix for the resources created in the specified Azure Resource Group | `string` | n/a | yes |
| public\_ssh\_key | A custom ssh key to control access to the AKS cluster | `string` | `""` | no |
| rbac\_enabled | Boolean to enable or disable role-based access control | `bool` | `true` | no |
| tags | Any tags that should be present on resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aks\_resource\_group | Resource Group object which AKS resides in |
| client\_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| client\_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| cluster\_ca\_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| cluster\_name | n/a |
| host | The Kubernetes cluster server host. |
| kube\_config\_raw | Raw Kubernetes config to be used by kubectl and other compatible tools. |
| location | The location where the Managed Kubernetes Cluster was created. |
| node\_resource\_group | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. |
| password | A password or token used to authenticate to the Kubernetes cluster. |
| username | A username used to authenticate to the Kubernetes cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



## Usage

```hcl
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "2.0.0"

  CLIENT_ID = "your-service-principal-client-appid"
  CLIENT_SECRET = "your-service-principal-client-password"
  prefix = "your-custom-resource-prefix"
}
```

This module is configured through variables. Make sure to select an [Azure location that supports AKS](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=kubernetes-service) and to [have a Service Principal created](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html). If no public ssh key is set through variables, a newly generated public key will be used and the private key will be saved in a *private_ssh_key* file.

See below for the default variable values.

```hcl
variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "location" {
  default     = "eastus"
  description = "The location for the AKS deployment"
}

variable "CLIENT_ID" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
}

variable "CLIENT_SECRET" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
}

variable "agents_size" {
  default     = "Standard_F2"
  description = "The default virtual machine size for the Kubernetes agents"
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  default     = 30
}

variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool"
  default     = 2
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to install"
  default     = "1.14.5"
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  default     = ""
}
```

The module supports some outputs that may be used to configure a kubernetes
provider after deploying an AKS cluster.

```
provider "kubernetes" {
  host = "${module.aks.host}"

  client_certificate     = "${base64decode(module.aks.client_certificate)}"
  client_key             = "${base64decode(module.aks.client_key)}"
  cluster_ca_certificate = "${base64decode(module.aks.cluster_ca_certificate)}"
}
```

## Authors

Originally created by [Damien Caro](http://github.com/dcaro) and [Malte Lantin](http://github.com/n01d) and
maintained for a short period of time

## License

[MIT](LICENSE)
