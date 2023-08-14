terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.51, < 4.0"
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

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "local_sensitive_file" "k8s_config" {
  filename = "${path.module}/k8sconfig"
  content  = module.aks.kube_config_raw

  depends_on = [module.aks]
}

# DO NOT DO THIS IN PRODUCTION ENVIRONMENT
provider "kubernetes" {
  config_path = local_sensitive_file.k8s_config.filename
  #  host                   = module.aks.admin_host
  #  client_certificate     = base64decode(module.aks.admin_client_certificate)
  #  client_key             = base64decode(module.aks.admin_client_key)
  #  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
}

provider "random" {}