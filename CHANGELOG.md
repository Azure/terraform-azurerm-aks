# Changelog

## [Unreleased](https://github.com/Azure/terraform-azurerm-aks/tree/HEAD)

**Merged pull requests:**

- Bump github.com/gruntwork-io/terratest from 0.41.6 to 0.41.7 in /test [\#286](https://github.com/Azure/terraform-azurerm-aks/pull/286) ([dependabot[bot]](https://github.com/apps/dependabot))
- Add support for `scale_down_mode` [\#285](https://github.com/Azure/terraform-azurerm-aks/pull/285) ([lonegunmanb](https://github.com/lonegunmanb))

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
