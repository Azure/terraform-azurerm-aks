output "host" {
  description = "The Kubernetes cluster server host."
  value       = module.aks.host
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  value       = module.aks.client_key
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  value       = module.aks.client_certificate
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  value       = module.aks.cluster_ca_certificate
}

output "username" {
  description = "A username used to authenticate to the Kubernetes cluster."
  value       = module.aks.username
}

output "password" {
  description = "A password or token used to authenticate to the Kubernetes cluster."
  value       = module.aks.password
}
