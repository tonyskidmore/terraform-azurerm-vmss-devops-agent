provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

output "account_id" {
  value = data.azurerm_client_config.current
}
