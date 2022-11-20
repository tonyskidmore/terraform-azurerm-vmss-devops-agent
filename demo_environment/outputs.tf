output "storage_account_name" {
  value       = azurerm_storage_account.demo-vmss.name
  description = "Azure storage account name"
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "Azure storage container name"
}

output "key" {
  value       = "000-bootstrap.tfstate"
  description = "Azure storage blob name"
}

output "resource_group_name" {
  value       = azurerm_resource_group.demo-vmss.name
  description = "Azure storage resource group name"
}
