# tflint-ignore-file: terraform_required_version_declaration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}