## 6.0.0 (August 10, 2022)

The goal of v6.0.0 is to add a GitHub Action-based CI pipeline and introduce modern acceptance tests to ensure that future pull requests to this module meet our new standard for AzureRM modules.

ENHANCEMENTS:

* Loose the restriction on `tls` provider's version to include major version greater than 3.0. [#228](https://github.com/Azure/terraform-azurerm-aks/issues/228)
* Mark some outputs as sensitive. [#231](https://github.com/Azure/terraform-azurerm-aks/pull/231)
* Output Kubernetes Cluster Name. [#234](https://github.com/Azure/terraform-azurerm-aks/pull/234)
