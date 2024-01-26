# Testing the upgrade scenario

You can use this example to manually test the upgrade scenario.

See existing AKS versions:

```
% az aks get-versions --location centralus
KubernetesVersion    Upgrades
-------------------  ------------------------
1.28.3               None available
1.28.0               1.28.3
1.27.7               1.28.0, 1.28.3
1.27.3               1.27.7, 1.28.0, 1.28.3
1.26.10              1.27.3, 1.27.7
1.26.6               1.26.10, 1.27.3, 1.27.7
1.25.15              1.26.6, 1.26.10
1.25.11              1.25.15, 1.26.6, 1.26.10
```

In this example we test an upgrade from 1.26.10 to 1.27.7.

## Create the AKS cluster at version 1.26.10:

```
terraform init -upgrade
terraform apply -var="kubernetes_version=1.26.10" -var="orchestrator_version=1.26.10"
```

Verify the AKS cluster version:

```
az aks list -o table # check AKS version
az aks get-credentials --resource-group <rg> --name <name>
kubectl version # check api server version
kubectl get nodes # check nodes version
```

In the `az aks list` output you will have `KubernetesVersion` and `CurrentKubernetesVersion` both at 1.26.10

## Upgrade the AKS cluster control plane only to version 1.27.7

```
terraform apply -var="kubernetes_version=1.27.7" -var="orchestrator_version=1.26.10"
```

Check the new versions:


```
az aks list -o table # check AKS version
kubectl version # check api server version
kubectl get nodes # check nodes version
```

In the `az aks list` output you will have `KubernetesVersion` and `CurrentKubernetesVersion` both at 1.27.7
The control plane version will be 1.27.7 and the nodes will be 1.26.10.

## Upgrade the AKS cluster node pools to version 1.27.7

```
terraform apply -var="kubernetes_version=1.27.7" -var="orchestrator_version=1.27.7"
```

Check the new versions:

```
az aks list -o table # check AKS version
kubectl version # check api server version
kubectl get nodes # check nodes version
```

In the `az aks list` output you will have `KubernetesVersion` and `CurrentKubernetesVersion` both at 1.27.7
The control plane version will be 1.27.7 and the nodes will be 1.27.7.

## Note on Issue #465

The current implementation does not allow to upgrade `var.kubernetes_version` and `var.orchestrator_version` at the same time.

We can test at this point a simultaneous upgrade to 1.28.3:

```
terraform apply -var="kubernetes_version=1.28.3" -var="orchestrator_version=1.28.3"
```
This will generate a plan where the azure_kubernetes_cluster resource is updated in place and the system node pool is updated.

```
  # module.aks.azurerm_kubernetes_cluster.main will be updated in-place
  ~ resource "azurerm_kubernetes_cluster" "main" {
        id                                  = "/subscriptions/<redacted>/resourceGroups/4c273d71bc7898d6-rg/providers/Microsoft.ContainerService/managedClusters/prefix-4c273d71bc7898d6-aks"
        name                                = "prefix-4c273d71bc7898d6-aks"
        tags                                = {}
        # (29 unchanged attributes hidden)

      ~ default_node_pool {
            name                         = "nodepool"
          ~ orchestrator_version         = "1.27.7" -> "1.28.3"
            tags                         = {}
            # (22 unchanged attributes hidden)
        }

        # (4 unchanged blocks hidden)
    }
```

that will fail with the following error:

```
│ Error: updating Default Node Pool Agent Pool (Subscription: "<redacted>"
│ Resource Group Name: "4c273d71bc7898d6-rg"
│ Managed Cluster Name: "prefix-4c273d71bc7898d6-aks"
│ Agent Pool Name: "nodepool") performing CreateOrUpdate: agentpools.AgentPoolsClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="NodePoolMcVersionIncompatible" Message="Node pool version 1.28.3 and control plane version 1.27.7 are incompatible. Minor version of node pool version 28 is bigger than control plane version 27. For more information, please check https://aka.ms/aks/UpgradeVersionRules"
```
