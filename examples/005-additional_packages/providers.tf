terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.15.0, < 2.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.69.0, < 5.0.0"
    }
  }
  required_version = ">= 1.5.0"
  backend "azurerm" {}
}
