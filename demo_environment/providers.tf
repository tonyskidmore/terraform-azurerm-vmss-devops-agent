
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.3.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">=3.4.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "~>1.7.10"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
    null = {
      version = ">= 3.2.1"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}
