terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

output "account_id" {
  value = data.azurerm_client_config.current
}
