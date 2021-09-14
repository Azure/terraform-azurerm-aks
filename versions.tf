
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.75"
    }
  }

  required_version = ">= 0.12"
}
