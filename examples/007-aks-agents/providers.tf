terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0, < 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">=3.4.0"
    }
  }
}
