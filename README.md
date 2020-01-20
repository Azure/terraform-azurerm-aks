# terraform-azurerm-aks
## Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

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
