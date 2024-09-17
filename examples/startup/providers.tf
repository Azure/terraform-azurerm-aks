terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    curl = {
      source  = "anschoewe/curl"
      version = "1.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.4.0, < 2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy       = false
      purge_soft_deleted_keys_on_destroy = false
      recover_soft_deleted_key_vaults    = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "curl" {}

provider "random" {}

provider "azapi" {
  tenant_id       = "585bda71-88ce-428b-9832-95eaa3dce989"
  subscription_id = "072658bf-5309-4646-b3de-681288135009"
  use_oidc        = true
}