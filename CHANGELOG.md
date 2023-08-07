# Changelog

## [7.3.0](https://github.com/Azure/terraform-azurerm-aks/tree/7.3.0) (2023-08-03)

**Merged pull requests:**

- Add `location` and `resource_group_name` for `var.log_analytics_workspace` [\#412](https://github.com/Azure/terraform-azurerm-aks/pull/412) ([lonegunmanb](https://github.com/lonegunmanb))
- Fix \#405 incorrect role assignment resource [\#410](https://github.com/Azure/terraform-azurerm-aks/pull/410) ([lonegunmanb](https://github.com/lonegunmanb))

## [7.2.0](https://github.com/Azure/terraform-azurerm-aks/tree/7.2.0) (2023-07-10)

**Merged pull requests:**

- Bump google.golang.org/grpc from 1.51.0 to 1.53.0 in /test [\#406](https://github.com/Azure/terraform-azurerm-aks/pull/406) ([dependabot[bot]](https://github.com/apps/dependabot))
- Support for Azure CNI Cilium [\#398](https://github.com/Azure/terraform-azurerm-aks/pull/398) ([JitseHijlkema](https://github.com/JitseHijlkema))
- Use `lonegunmanb/public-ip/lonegunmanb` module to retrieve public ip [\#396](https://github.com/Azure/terraform-azurerm-aks/pull/396) ([lonegunmanb](https://github.com/lonegunmanb))
- Fix incorrect e2e test code so it could pass on our local machine [\#395](https://github.com/Azure/terraform-azurerm-aks/pull/395) ([lonegunmanb](https://github.com/lonegunmanb))
- Support for Proximity placement group for default node pool [\#392](https://github.com/Azure/terraform-azurerm-aks/pull/392) ([lonegunmanb](https://github.com/lonegunmanb))
- Add upgrade\_settings block for default nodepool [\#391](https://github.com/Azure/terraform-azurerm-aks/pull/391) ([CiucurDaniel](https://github.com/CiucurDaniel))
- Bump github.com/Azure/terraform-module-test-helper from 0.13.0 to 0.14.0 in /test [\#386](https://github.com/Azure/terraform-azurerm-aks/pull/386) ([dependabot[bot]](https://github.com/apps/dependabot))

## [7.1.0](https://github.com/Azure/terraform-azurerm-aks/tree/7.1.0) (2023-06-07)

**Merged pull requests:**

- Make `var.prefix` optional [\#382](https://github.com/Azure/terraform-azurerm-aks/pull/382) ([lonegunmanb](https://github.com/lonegunmanb))
- Deprecate `api_server_authorized_ip_ranges` by using `api_server_access_profile` block [\#381](https://github.com/Azure/terraform-azurerm-aks/pull/381) ([lonegunmanb](https://github.com/lonegunmanb))
- `oidc_issuer_enabled` must be set to `true` to enable Azure AD Worklo… [\#377](https://github.com/Azure/terraform-azurerm-aks/pull/377) ([zioproto](https://github.com/zioproto))
- Remove constraint on `authorized_ip_ranges` when `public_network_access_enabled` is `true` [\#375](https://github.com/Azure/terraform-azurerm-aks/pull/375) ([lonegunmanb](https://github.com/lonegunmanb))
- Filter null value out from `local.subnet_ids` [\#374](https://github.com/Azure/terraform-azurerm-aks/pull/374) ([lonegunmanb](https://github.com/lonegunmanb))
- assign network contributor role to control plane identity [\#369](https://github.com/Azure/terraform-azurerm-aks/pull/369) ([zioproto](https://github.com/zioproto))
- Add tracing tag toggle variables [\#362](https://github.com/Azure/terraform-azurerm-aks/pull/362) ([lonegunmanb](https://github.com/lonegunmanb))
- Support for Azure CNI Overlay [\#354](https://github.com/Azure/terraform-azurerm-aks/pull/354) ([zioproto](https://github.com/zioproto))
- User `location` returned from data source for log analytics solution. [\#349](https://github.com/Azure/terraform-azurerm-aks/pull/349) ([lonegunmanb](https://github.com/lonegunmanb))

## [7.0.0](https://github.com/Azure/terraform-azurerm-aks/tree/7.0.0) (2023-05-18)

**Merged pull requests:**

- Upgrade notice for v7.0 [\#367](https://github.com/Azure/terraform-azurerm-aks/pull/367) ([lonegunmanb](https://github.com/lonegunmanb))
- Check `api_server_authorized_ip_ranges` when `public_network_access_enabled` is `true` [\#361](https://github.com/Azure/terraform-azurerm-aks/pull/361) ([lonegunmanb](https://github.com/lonegunmanb))
- feat!: add create\_before\_destroy=true to node pools [\#357](https://github.com/Azure/terraform-azurerm-aks/pull/357) ([the-technat](https://github.com/the-technat))
- Move breaking change details into separate docs. add notice on v7.0.0 [\#355](https://github.com/Azure/terraform-azurerm-aks/pull/355) ([lonegunmanb](https://github.com/lonegunmanb))
- Bump github.com/Azure/terraform-module-test-helper from 0.12.0 to 0.13.0 in /test [\#352](https://github.com/Azure/terraform-azurerm-aks/pull/352) ([dependabot[bot]](https://github.com/apps/dependabot))
- Trivial: fix typo ingration -\> integration [\#351](https://github.com/Azure/terraform-azurerm-aks/pull/351) ([zioproto](https://github.com/zioproto))
- Output Kubernetes Cluster Network Profile [\#333](https://github.com/Azure/terraform-azurerm-aks/pull/333) ([joshua-giumelli-deltatre](https://github.com/joshua-giumelli-deltatre))
- \[Breaking\] Add validation block to enforce users to change `sku_tier` from `Paid` to `Standard`. [\#346](https://github.com/Azure/terraform-azurerm-aks/pull/346) ([lonegunmanb](https://github.com/lonegunmanb))
- \[Breaking\] - Ignore changes on `kubernetes_version` from outside of Terraform [\#336](https://github.com/Azure/terraform-azurerm-aks/pull/336) ([lonegunmanb](https://github.com/lonegunmanb))
- \[Breaking\] - Fix \#315 by amending missing `linux_os_config` block [\#320](https://github.com/Azure/terraform-azurerm-aks/pull/320) ([lonegunmanb](https://github.com/lonegunmanb))
- \[Breaking\]  Wrap `log_analytics_solution_id` to an object to fix \#263. [\#265](https://github.com/Azure/terraform-azurerm-aks/pull/265) ([lonegunmanb](https://github.com/lonegunmanb))
- \[Breaking\] Remove unused net\_profile\_docker\_bridge\_cidr [\#222](https://github.com/Azure/terraform-azurerm-aks/pull/222) ([zioproto](https://github.com/zioproto))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
