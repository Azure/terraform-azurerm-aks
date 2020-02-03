# azure CNI example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azuread | >=0.6.0 |
| azurerm | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| k8s\_version\_prefix | Minor Version of Kubernetes to target (ex: 1.14) | `string` | `"1.14"` | no |
| location | Name of file holding tfstate, should be unique for every tf module | `string` | `"eastus"` | no |
| name | n/a | `string` | `"testkube"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
