# Notice on Upgrade to v8.x

## New variable `cluster_name_random_suffix`

1. A new variable `cluster_name_random_suffix` is added. This allows users to decide whether they want to add a random suffix to a cluster's name. This is particularly useful when Terraform needs to recreate a resource that cannot be updated in-place, as it avoids naming conflicts. Because of [#357](https://github.com/Azure/terraform-azurerm-aks/pull/357), now the `azurerm_kubernetes_cluster` resource is `create_before_destroy = true` now, we cannot turn this feature off. If you want to recreate this cluster by one apply without any trouble, please turn this random naming suffix on to avoid the naming conflict.

2. The `create_before_destroy` attribute is added to the `node_pools` variable as an object field. This attribute determines whether a new node pool should be created before the old one is destroyed during updates. By default, it is set to `true`.

3. The naming of extra node pools has been updated. Now, a random UUID is used as the seed for the random suffix in the name of the node pool, instead of the JSON-encoded value of the node pool. **This naming suffix only apply for extra node pools that create before destroy.**

You're recommended to set `var.cluster_name_random_suffix` to `true` explicitly, and you'll see a random suffix in your cluster's name. If you don't like this suffix, please remember now a new cluster with the same name would be created before the old one has been deleted. If you do want to recreate the cluster, please run `terraform destroy` first.

## Remove `var.http_application_routing_enabled`

According to the [document](https://learn.microsoft.com/en-us/azure/aks/http-application-routing), HTTP application routing add-on for AKS has been retired so we have to remove this feature from this module.

1. The variable `http_application_routing_enabled` has been removed from the module. This variable was previously used to enable HTTP Application Routing Addon.

2. The `http_application_routing_enabled` output has been removed from `outputs.tf`. This output was previously used to display whether HTTP Application Routing was enabled.

3. The `http_application_routing_enabled` attribute has been removed from the `azurerm_kubernetes_cluster` resource in `main.tf`. This attribute was previously used to enable HTTP Application Routing for the Kubernetes cluster.

4. The `http_application_routing_enabled` attribute has been added to the `ignore_changes` lifecycle block of the `azurerm_kubernetes_cluster` resource in `main.tf`. This means changes to this attribute will not trigger the resource to be updated.

These changes mean that users of this module will no longer be able to enable HTTP Application Routing through this module.

The new feature for the Ingress in AKS is [Managed NGINX ingress with the application routing add-on](https://learn.microsoft.com/en-us/azure/aks/app-routing?tabs=default%2Cdeploy-app-default), you can enable this with `var.web_app_routing`.

Users who were using this feature, please read this [Migrate document](https://learn.microsoft.com/en-us/azure/aks/app-routing-migration).

## Remove `public_network_access_enabled` entirely

According to this [announcement](https://github.com/Azure/AKS/issues/3690), now public network access for AKS is no longer supported.

The primary impact [#488](https://github.com/Azure/terraform-azurerm-aks/pull/488) is the complete removal of the `public_network_access_enabled` variable from the module.

1. The `public_network_access_enabled` variable has been removed from the `variables.tf` file. This means that the module no longer supports the configuration of public network access at the Kubernetes cluster level.

2. The `public_network_access_enabled` variable has also been removed from the `main.tf` file and all example files (`application_gateway_ingress/main.tf`, `multiple_node_pools/main.tf`, `named_cluster/main.tf`, `startup/main.tf`, `with_acr/main.tf`, `without_monitor/main.tf`). This indicates that the module no longer uses this variable in the creation of the Azure Kubernetes Service (AKS) resource.

3. The `public_network_access_enabled` has been added into `azurerm_kubernetes_cluster`'s `ignore_changes` list. Any change to this attribute won't trigger update.

## Add role assignments for ingress application gateway

The `variables.tf` file is updated with new variables related to the application gateway for ingress, including `brown_field_application_gateway_for_ingress`, `create_role_assignments_for_application_gateway`, and `green_field_application_gateway_for_ingress`.

The `brown_field_application_gateway_for_ingress`, `create_role_assignments_for_application_gateway`, and `green_field_application_gateway_for_ingress` variables are used to configure the Application Gateway Ingress for the Azure Kubernetes Service (AKS) in the Terraform module.

1. `brown_field_application_gateway_for_ingress`: This variable is used when you want to use an existing Application Gateway as the ingress for the AKS cluster. It is an object that contains the ID of the Application Gateway (`id`) and the ID of the Subnet (`subnet_id`) which the Application Gateway is connected to. If this variable is set, the module will not create a new Application Gateway and will use the existing one instead.

2. `green_field_application_gateway_for_ingress`: This variable is used when you want the module to create a new Application Gateway for the AKS cluster. It is an object that contains the name of the Application Gateway to be used or created in the Nodepool Resource Group (`name`), the subnet CIDR to be used to create an Application Gateway (`subnet_cidr`), and the ID of the subnet on which to create an Application Gateway (`subnet_id`). If this variable is set, the module will create a new Application Gateway with the provided configuration.

3. `create_role_assignments_for_application_gateway`: This is a boolean variable that determines whether to create the corresponding role assignments for the application gateway or not. By default, it is set to `true`. Role assignments are necessary for the Application Gateway to function correctly with the AKS cluster. If set to `true`, the module will create the necessary role assignments on the Application Gateway.
