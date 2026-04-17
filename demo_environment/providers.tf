
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.15.0, < 2.0.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">= 3.8.1, < 4.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.69.0, < 5.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4, < 4.0.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}
