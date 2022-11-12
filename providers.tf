terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "~>1.7.10"
    }
  }

  required_version = ">= 1.0.0"
}
