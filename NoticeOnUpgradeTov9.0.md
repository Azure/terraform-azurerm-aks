# Notice on Upgrade to v9.x

## New default value for variable `agents_pool_max_surge`

variable `agents_pool_max_surge` now has default value `10%`. This change might cause configuration drift. If you want to keep the old value, please set it explicitly in your configuration.

## API version for `azapi_update_resource` resource has been upgraded from `Microsoft.ContainerService/managedClusters@2023-01-02-preview` to `Microsoft.ContainerService/managedClusters@2024-02-01`.

After a test, it won't affect the existing Terraform state and cause configuration drift. The upgrade is caused by the retirement of original API.
