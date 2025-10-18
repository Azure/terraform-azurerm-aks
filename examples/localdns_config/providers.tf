terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">=2.0, < 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.16.0, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  required_version = ">= 1.3"
}

provider "azurerm" {
  features {}
}

provider "azapi" {}