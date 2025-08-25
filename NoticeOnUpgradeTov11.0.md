# Notice on Upgrade to v10.x

`v11.0.0` removed support for Terraform AzureRM provider `v3` and removed `//v4` folder. All users need to use `Azure/aks/azurerm` instead of `Azure/aks/azurerm//v4` as module `source`.
