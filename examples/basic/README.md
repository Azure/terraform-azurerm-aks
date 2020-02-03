# basic example

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
| name | Moniker to apply to all resources in module | `string` | `"testkube"` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| client\_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| cluster\_ca\_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| host | The Kubernetes cluster server host. |
| password | A password or token used to authenticate to the Kubernetes cluster. |
| username | A username used to authenticate to the Kubernetes cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
