## 6.0.0 (August 10, 2022)

The goal of v6.0.0 is to add a GitHub Action-based CI pipeline and introduce modern acceptance tests to ensure that future pull requests to this module meet our new standard for AzureRM modules.

ENHANCEMENTS:

* Loose the restriction on `tls` provider's version to include major version greater than 3.0. [#228](https://github.com/Azure/terraform-azurerm-aks/issues/228)
* Mark some outputs as sensitive. [#231](https://github.com/Azure/terraform-azurerm-aks/pull/231)
* Output Kubernetes Cluster Name. [#234](https://github.com/Azure/terraform-azurerm-aks/pull/234)
* Add Microsoft Defender support. [#232](https://github.com/Azure/terraform-azurerm-aks/pull/232)
* Add outputs for created Log Analytics workspace. [#243](https://github.com/Azure/terraform-azurerm-aks/pull/243)

BUG FIXES:

* Update hashicorp/terraform-provider-azurerm to version 3.21.0. [#238](https://github.com/Azure/terraform-azurerm-aks/pull/238)

## 6.1.0 (September 30, 2022)

ENHANCEMENTS:

* Add `aci_connector_linux` addon. [#230](https://github.com/Azure/terraform-azurerm-aks/pull/230)
* Restrict Terraform Core version for example cod to `>= 1.2`. [#253](https://github.com/Azure/terraform-azurerm-aks/pull/253)
* Adds support for Ultra Disks by enabling the option. [#245](https://github.com/Azure/terraform-azurerm-aks/pull/245)
* Add new outputs: `cluster_fqdn`, `cluster_portal_fqdn` and `cluster_private_fqdn`. [#251](https://github.com/Azure/terraform-azurerm-aks/pull/245)
* Add new variable `maintenance_window` so we can set `maintenance_window` argument for `azurerm_kubernetes_cluster` resource. [#256](https://github.com/Azure/terraform-azurerm-aks/pull/245)
* Change Terraform AzureRM Provider version to `>= 3.21`. [#248](https://github.com/Azure/terraform-azurerm-aks/pull/248)

BUG FIXES:

* Make the Azure Defender clause robust against a non-existent `log_analytics_workspace`. [#258](https://github.com/Azure/terraform-azurerm-aks/pull/258)

## 6.2.0 (October 18, 2022)

ENHANCEMENTS:

* Add new variable `workload_identity_enabled`. [#266](https://github.com/Azure/terraform-azurerm-aks/pull/266)

BUG FIXES:
