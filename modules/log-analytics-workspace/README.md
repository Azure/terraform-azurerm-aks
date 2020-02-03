#  log-analytics-workspace

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| location | The Azure Region in which to create the Virtual Network | `any` | n/a | yes |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace | `string` | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| prefix | The prefix for the resources created in the specified Azure Resource Group. | `any` | n/a | yes |
| resource\_group\_name | The name of the Resource Group in which the Virtual Network | `any` | n/a | yes |
| retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| sku | The SKU (pricing level) of the Log Analytics workspace | `string` | `"PerGB2018"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
