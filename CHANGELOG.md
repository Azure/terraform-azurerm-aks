# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2022-05-09

### Added
- `node_taints` to default node pool
  
### Changed
- Upgraded to Terraform 1.1.9 from 0.13.0
- Upgraded to azurerm provider 3.x from 2.x
- Split `prefix` and `dns_prefix`, as they might not be the same
- Separated Log Analytics Workspace and Log Analytics Solutions, for users who do not want both resources
- Renamed most variables to be more consistent with resources
- Required azurerm provider to >= 3.0.0 from ~> 2.46
- Split tests into Kubenet and Azure CNI AKS clusters
- Reduced test outputs to bare necessities
  
### Fixed
- Fixed typos and mistakes in variables descriptions
- `role_based_access_control` has been deprecated in favor of `azure_active_directory_role_based_access_control`
- `addon_profile` block has been deprecated in azurerm 3.0
- Duplicate `default_node_pool` was removed and replaced with in-block ternary
- Renamed CHANGLOG.md to CHANGELOG.md

### Security
- In-repo ssh module. This generated a local file on the agent with a private key (highly unsafe!) and was unused. Replaced by a `tls_private_key` block without a file output

### Removed
- `max_node`, `min_node` and `node_count` are not mutually exclusive.
- `agent_` particle in variables.tf. AKS uses node pools and nodes in their terminology

## [4.15.0] - 2022-05-06
### Added
- Added output for `kube_admin_config_raw` ([#146](https://github.com/Azure/terraform-azurerm-aks/pull/146))
- Include `node_resource_group` as variable ([#136](https://github.com/Azure/terraform-azurerm-aks/pull/136))


[5.0.0]:https://github.com/Azure/terraform-azurerm-aks/releases/tag/5.0.0
[4.15.0]:https://github.com/Azure/terraform-azurerm-aks/releases/tag/4.15.0