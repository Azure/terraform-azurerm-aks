
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.34"
    }
  }

  required_version = ">= 0.12"
}
