variable "resource_group_name" {
  description = "Please input a new Azure Resource group name "
}

variable "kube_version" {
  description = "Please input the k8s version -  1.11.3 is the latest in westeurope or eastus"
}

variable "location" {
  description = "Please input the Azure region for deployment - for e.g: westeurope or eastus "
}

variable "client_id" {
  description = "Please input the Azure Application ID known as client_id or AD ServicePrincipal App ID"
}

variable "client_secret" {
  description = "Please input the Azure client secret for the Azure Application ID known as client_id or AD ServicePrincipal App Secret"
}

variable "cluster_name" {
  description = "Please input the k8s cluster name to create"
}

variable "dns_prefix" {
  description = "Please input the DNS prefix to create"
}

variable "azure_container_registry_name" {
  description = "Please input the ACR name to create in the same Resource Group"
}

variable "helm_install_jenkins" {
  description = "Please input whether to install Jenkins by default- true or false"
}

variable "patch_svc_lbr_external_ip" {
  description = "Please input to patch grafana, kubernetes-dashboard service for LBR Ingress External IP (expose)- true or false"
}

variable "ssh_public_key" {
  default = "~/aks-terraform/id_rsa.pub"
}

variable "admin_username" {
  default = "aksadmin"
}

variable "agent_count" {
  description = "Number of Cluster Agent Nodes (GPU Quota is defaulted to only 1 Standard_NC6 per subscription) - Please view https://docs.microsoft.com/en-us/azure/aks/faq#are-security-updates-applied-to-aks-agent-nodes"
}

variable "azurek8s_sku" {
  description = "Sku of Cluster node- Recommend -Standard_F4s_v2- for normal and -Standard_NC6- for GPU (GPU Quota is defaulted to only 1 per subscription) Please view Azure Linux VM Sizes at https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes"
}

variable "resource_storage_acct" {
  default = "acisa12345"
}
variable "install_suitecrm" {
  description = "Install SuiteCRM with MariaDB - true or false"
}
/**
variable "cluster_name" {
  default = "hclaks"
}

variable "dns_prefix" {
  default = "hclaks"
}
variable "resource_group_name" {
  default = "hclaks"
}

variable "location" {
  default = "westeurope"
}

variable "client_id" {
  default     = ""
}

variable "client_secret" {
  default     = ""
}

variable "resource_aci-dev-share" {
  default = "aci-dev-share"
}

variable "resource_aci-hw" {
  default = "aci-helloworld"
}

variable "resource_dns_aci-label" {
  default = "aci-dev-hw"
}
**/
locals {
  username = "clusterUser_${var.cluster_name}_{$var.cluster_name}"
}
