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
