terraform {
  required_version = ">= 1.3"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.4.0, < 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.84.0, < 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
  }
}
