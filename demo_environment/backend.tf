terraform {
  backend "azurerm" {
    resource_group_name  = "rg-demo-azure-devops-vmss"
    storage_account_name = "sademovmss715239"
    container_name       = "tfstate"
    key                  = "000-bootstrap.tfstate"
  }
}
