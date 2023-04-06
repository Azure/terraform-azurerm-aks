# Changelog

## [Unreleased](https://github.com/Azure/terraform-azurerm-aks/tree/HEAD)

**Merged pull requests:**

- Output Kubernetes Cluster Network Profile [\#333](https://github.com/Azure/terraform-azurerm-aks/pull/333) ([joshua-giumelli-deltatre](https://github.com/joshua-giumelli-deltatre))

## [6.8.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.8.0) (2023-04-04)

**Merged pull requests:**

- Add support for `monitor_metrics` [\#341](https://github.com/Azure/terraform-azurerm-aks/pull/341) ([zioproto](https://github.com/zioproto))
- Support setting os\_sku for default\_node\_pool [\#339](https://github.com/Azure/terraform-azurerm-aks/pull/339) ([mjeco](https://github.com/mjeco))
- Upgrade required Terraform version [\#338](https://github.com/Azure/terraform-azurerm-aks/pull/338) ([lonegunmanb](https://github.com/lonegunmanb))
- Add support `temporary_name_for_rotation` [\#334](https://github.com/Azure/terraform-azurerm-aks/pull/334) ([lonegunmanb](https://github.com/lonegunmanb))
- Bump github.com/Azure/terraform-module-test-helper from 0.9.1 to 0.12.0 in /test [\#330](https://github.com/Azure/terraform-azurerm-aks/pull/330) ([dependabot[bot]](https://github.com/apps/dependabot))
- Fix example multiple\_node\_pools [\#328](https://github.com/Azure/terraform-azurerm-aks/pull/328) ([lonegunmanb](https://github.com/lonegunmanb))
- Add Network Contributor role assignments scoped to AKS nodepools subnets [\#327](https://github.com/Azure/terraform-azurerm-aks/pull/327) ([zioproto](https://github.com/zioproto))
- Add support for extra node pools [\#323](https://github.com/Azure/terraform-azurerm-aks/pull/323) ([lonegunmanb](https://github.com/lonegunmanb))
- Add support for `default_node_pool.kubelet_config` [\#322](https://github.com/Azure/terraform-azurerm-aks/pull/322) ([lonegunmanb](https://github.com/lonegunmanb))
- Support for `public_network_access_enabled` [\#314](https://github.com/Azure/terraform-azurerm-aks/pull/314) ([lonegunmanb](https://github.com/lonegunmanb))

## [6.7.1](https://github.com/Azure/terraform-azurerm-aks/tree/6.7.1) (2023-03-06)

**Merged pull requests:**

- Fix \#316 `current client lacks permissions to read Key Rotation Policy` issue [\#317](https://github.com/Azure/terraform-azurerm-aks/pull/317) ([lonegunmanb](https://github.com/lonegunmanb))

## [6.7.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.7.0) (2023-02-27)

**Merged pull requests:**

- Add support for `linux_os_config` [\#309](https://github.com/Azure/terraform-azurerm-aks/pull/309) ([lonegunmanb](https://github.com/lonegunmanb))
- Bump github.com/gruntwork-io/terratest from 0.41.10 to 0.41.11 in /test [\#307](https://github.com/Azure/terraform-azurerm-aks/pull/307) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github.com/Azure/terraform-module-test-helper from 0.8.1 to 0.9.1 in /test [\#306](https://github.com/Azure/terraform-azurerm-aks/pull/306) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump golang.org/x/net from 0.1.0 to 0.7.0 in /test [\#305](https://github.com/Azure/terraform-azurerm-aks/pull/305) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github.com/hashicorp/go-getter from 1.6.1 to 1.7.0 in /test [\#304](https://github.com/Azure/terraform-azurerm-aks/pull/304) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github.com/hashicorp/go-getter/v2 from 2.1.1 to 2.2.0 in /test [\#303](https://github.com/Azure/terraform-azurerm-aks/pull/303) ([dependabot[bot]](https://github.com/apps/dependabot))
- fix: allow orchestrator\_version if auto-upgrade is 'patch' to allow default\_node\_pool upgrade [\#302](https://github.com/Azure/terraform-azurerm-aks/pull/302) ([aescrob](https://github.com/aescrob))
- Add support for default node pool's `node_taints` [\#300](https://github.com/Azure/terraform-azurerm-aks/pull/300) ([lonegunmanb](https://github.com/lonegunmanb))
- Add support for acr attachment [\#298](https://github.com/Azure/terraform-azurerm-aks/pull/298) ([lonegunmanb](https://github.com/lonegunmanb))
- Add support for `web_app_routing` [\#297](https://github.com/Azure/terraform-azurerm-aks/pull/297) ([lonegunmanb](https://github.com/lonegunmanb))
- Bump github.com/Azure/terraform-module-test-helper from 0.7.1 to 0.8.1 in /test [\#295](https://github.com/Azure/terraform-azurerm-aks/pull/295) ([dependabot[bot]](https://github.com/apps/dependabot))

## [6.6.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.6.0) (2023-01-29)

**Merged pull requests:**

- Bump github.com/Azure/terraform-module-test-helper from 0.6.0 to 0.7.1 in /test [\#293](https://github.com/Azure/terraform-azurerm-aks/pull/293) ([dependabot[bot]](https://github.com/apps/dependabot))
- identity type is either SystemAssigned or UserAssigned [\#292](https://github.com/Azure/terraform-azurerm-aks/pull/292) ([zioproto](https://github.com/zioproto))
- Bump github.com/gruntwork-io/terratest from 0.41.7 to 0.41.9 in /test [\#290](https://github.com/Azure/terraform-azurerm-aks/pull/290) ([dependabot[bot]](https://github.com/apps/dependabot))
- feat: Implement support for KMS arguments [\#288](https://github.com/Azure/terraform-azurerm-aks/pull/288) ([mkilchhofer](https://github.com/mkilchhofer))
- feat: allow for configuring auto\_scaler\_profile [\#278](https://github.com/Azure/terraform-azurerm-aks/pull/278) ([DavidSpek](https://github.com/DavidSpek))
- Azure AD RBAC enable/disable with variable rbac\_aad [\#269](https://github.com/Azure/terraform-azurerm-aks/pull/269) ([zioproto](https://github.com/zioproto))

## [6.5.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.5.0) (2023-01-03)

**Merged pull requests:**

- Bump github.com/Azure/terraform-module-test-helper from 0.4.0 to 0.6.0 in /test [\#287](https://github.com/Azure/terraform-azurerm-aks/pull/287) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github.com/gruntwork-io/terratest from 0.41.6 to 0.41.7 in /test [\#286](https://github.com/Azure/terraform-azurerm-aks/pull/286) ([dependabot[bot]](https://github.com/apps/dependabot))
- Add support for `scale_down_mode` [\#285](https://github.com/Azure/terraform-azurerm-aks/pull/285) ([lonegunmanb](https://github.com/lonegunmanb))
- auto-upgrade: variable orchestrator\_version to null [\#283](https://github.com/Azure/terraform-azurerm-aks/pull/283) ([zioproto](https://github.com/zioproto))

## [6.4.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.4.0) (2022-12-26)

**Merged pull requests:**

- feat\(storage\_profile\): add support for CSI arguments [\#282](https://github.com/Azure/terraform-azurerm-aks/pull/282) ([aescrob](https://github.com/aescrob))

## [6.3.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.3.0) (2022-12-20)

**Merged pull requests:**

- feat: add var automatic\_channel\_upgrade [\#281](https://github.com/Azure/terraform-azurerm-aks/pull/281) ([the-technat](https://github.com/the-technat))
- Upgrade `terraform-module-test-helper` lib so we can get rid of override file to execute version upgrade test [\#279](https://github.com/Azure/terraform-azurerm-aks/pull/279) ([lonegunmanb](https://github.com/lonegunmanb))
- Added support for load\_balancer\_profile [\#277](https://github.com/Azure/terraform-azurerm-aks/pull/277) ([mazilu88](https://github.com/mazilu88))
- Add auto changelog update to this repo. [\#275](https://github.com/Azure/terraform-azurerm-aks/pull/275) ([lonegunmanb](https://github.com/lonegunmanb))
- Bump test helper version  [\#273](https://github.com/Azure/terraform-azurerm-aks/pull/273) ([lonegunmanb](https://github.com/lonegunmanb))
- Ignore `scripts` soft link [\#272](https://github.com/Azure/terraform-azurerm-aks/pull/272) ([lonegunmanb](https://github.com/lonegunmanb))
- Add support for pod subnet [\#271](https://github.com/Azure/terraform-azurerm-aks/pull/271) ([mr-onion-2](https://github.com/mr-onion-2))

## [6.2.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.2.0) (2022-10-18)

**Merged pull requests:**

- Add breaking change detect CI step. [\#268](https://github.com/Azure/terraform-azurerm-aks/pull/268) ([lonegunmanb](https://github.com/lonegunmanb))
- Workload Identity support [\#266](https://github.com/Azure/terraform-azurerm-aks/pull/266) ([nlamirault](https://github.com/nlamirault))
- Add unit test for complex local logic [\#264](https://github.com/Azure/terraform-azurerm-aks/pull/264) ([lonegunmanb](https://github.com/lonegunmanb))

## [6.1.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.1.0) (2022-09-30)

**Merged pull requests:**

- Improve placeholders for visibility in the UX [\#262](https://github.com/Azure/terraform-azurerm-aks/pull/262) ([zioproto](https://github.com/zioproto))
- align acc test in CI pipeline with local machine by running e2e test … [\#260](https://github.com/Azure/terraform-azurerm-aks/pull/260) ([lonegunmanb](https://github.com/lonegunmanb))
- align pr-check with local machine by using docker command instead [\#259](https://github.com/Azure/terraform-azurerm-aks/pull/259) ([lonegunmanb](https://github.com/lonegunmanb))
- bugfix: Make the Azure Defender clause robust against a non-existent … [\#258](https://github.com/Azure/terraform-azurerm-aks/pull/258) ([gzur](https://github.com/gzur))
- Add support for `maintenance_window` [\#256](https://github.com/Azure/terraform-azurerm-aks/pull/256) ([lonegunmanb](https://github.com/lonegunmanb))
- Updates terraform code to meet updated code style requirement [\#253](https://github.com/Azure/terraform-azurerm-aks/pull/253) ([lonegunmanb](https://github.com/lonegunmanb))
- Output cluster's fqdn [\#251](https://github.com/Azure/terraform-azurerm-aks/pull/251) ([lonegunmanb](https://github.com/lonegunmanb))
- Fix example path in readme file. [\#249](https://github.com/Azure/terraform-azurerm-aks/pull/249) ([lonegunmanb](https://github.com/lonegunmanb))
- Update azurerm provider's restriction. [\#248](https://github.com/Azure/terraform-azurerm-aks/pull/248) ([lonegunmanb](https://github.com/lonegunmanb))
- Support for optional Ultra disks [\#245](https://github.com/Azure/terraform-azurerm-aks/pull/245) ([digiserg](https://github.com/digiserg))
- add aci\_connector addon [\#230](https://github.com/Azure/terraform-azurerm-aks/pull/230) ([zioproto](https://github.com/zioproto))

## [6.0.0](https://github.com/Azure/terraform-azurerm-aks/tree/6.0.0) (2022-09-13)

**Merged pull requests:**

- Add outputs for created Log Analytics workspace [\#243](https://github.com/Azure/terraform-azurerm-aks/pull/243) ([zioproto](https://github.com/zioproto))
- Prepare v6.0 and new CI pipeline. [\#241](https://github.com/Azure/terraform-azurerm-aks/pull/241) ([lonegunmanb](https://github.com/lonegunmanb))
- Update hashicorp/terraform-provider-azurerm to version 3.21.0 \(fixes for AKS 1.24\) [\#238](https://github.com/Azure/terraform-azurerm-aks/pull/238) ([zioproto](https://github.com/zioproto))
- Output Kubernetes Cluster Name [\#234](https://github.com/Azure/terraform-azurerm-aks/pull/234) ([vermacodes](https://github.com/vermacodes))
- feat\(aks\): add microsoft defender support [\#232](https://github.com/Azure/terraform-azurerm-aks/pull/232) ([eyenx](https://github.com/eyenx))
- fix: mark outputs as sensitive [\#231](https://github.com/Azure/terraform-azurerm-aks/pull/231) ([jvelasquez](https://github.com/jvelasquez))
- Loose the restriction on tls provider's version to include major version greater than 3.0 [\#229](https://github.com/Azure/terraform-azurerm-aks/pull/229) ([lonegunmanb](https://github.com/lonegunmanb))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
