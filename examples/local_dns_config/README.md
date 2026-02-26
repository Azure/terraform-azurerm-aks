# LocalDNS Configuration Example

This example demonstrates how to use the `local_dns_config` feature in the terraform-azurerm-aks module to configure LocalDNS settings for your AKS cluster.

## Overview

LocalDNS in AKS allows you to customize DNS resolution behavior for pods with different DNS policies:

- **VNet DNS Overrides**: Configuration for pods using `dnsPolicy: default` (uses VNet DNS)
- **Kube DNS Overrides**: Configuration for pods using `dnsPolicy: ClusterFirst` (uses Kubernetes CoreDNS)

## Configuration Features

This example configures:

1. **Mode**: Set to `Required` to enforce LocalDNS usage
2. **VNet DNS Overrides**:
   - Root zone (`.`) configured to use VNet DNS with caching and stale serving
   - Custom zone (`example.local`) with round-robin policy
3. **Kube DNS Overrides**:
   - Cluster-local zone (`cluster.local`) using CoreDNS with enhanced caching
   - Service discovery zone (`svc.cluster.local`) for Kubernetes services

## Key Configuration Options

### DNS Zone Configuration

Each zone can be configured with:

- **Query Logging**: Set to `Error` or `Log` for different verbosity levels
- **Protocol**: `PreferUDP` (default) or `ForceTCP` for transport protocol
- **Forward Destination**: `VnetDNS` or `ClusterCoreDNS` based on the zone type
- **Forward Policy**: `Random`, `RoundRobin`, or `Sequential` for upstream server selection
- **Caching**: Configure cache duration and stale serving policies
- **Concurrency**: Control maximum concurrent queries

### Important Constraints

- Root zone (`.`) under `vnet_dns_overrides` cannot use `ClusterCoreDNS`
- Zone `cluster.local` cannot use `VnetDNS` as forward destination
- When protocol is `ForceTCP`, serve_stale cannot be `Verify`

## Usage

1. Set your Azure credentials:
   ```bash
   export ARM_CLIENT_ID="your-client-id"
   export ARM_CLIENT_SECRET="your-client-secret"
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   ```

2. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Connect to your AKS cluster:
   ```bash
   az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw aks_cluster_name)
   ```

## Testing LocalDNS Configuration

After deployment, you can test the LocalDNS configuration:

```bash
# Test DNS resolution from a pod
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup kubernetes.default.svc.cluster.local

# Check LocalDNS pods
kubectl get pods -n kube-system -l k8s-app=node-local-dns

# View LocalDNS configuration
kubectl get configmap node-local-dns -n kube-system -o yaml
```

## Cleanup

```bash
terraform destroy
```

## More Information

- [Azure LocalDNS Documentation](https://learn.microsoft.com/en-us/azure/aks/localdns-custom)
- [Kubernetes DNS Policies](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy)
