output "host" {
  description = "The Kubernetes cluster server host."
  value       = module.kubernetes.host
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  value       = module.kubernetes.client_key
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  value       = module.kubernetes.client_certificate
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  value       = module.kubernetes.cluster_ca_certificate
}

output "username" {
  description = "A username used to authenticate to the Kubernetes cluster."
  value       = module.kubernetes.username
}

output "password" {
  description = "A password or token used to authenticate to the Kubernetes cluster."
  value       = module.kubernetes.password
}

output "node_resource_group" {
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
  value       = module.kubernetes.node_resource_group
}

output "location" {
  description = "The location where the Managed Kubernetes Cluster was created."
  value       = module.kubernetes.location
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
  value       = module.kubernetes.kube_config_raw
}
