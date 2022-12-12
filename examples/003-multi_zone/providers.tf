terraform {
  required_providers {
    shell = {
      source  = "scottwinkler/shell"
      version = "~>1.7.10"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
  required_version = ">= 1.0.0"
  backend "azurerm" {}
}
