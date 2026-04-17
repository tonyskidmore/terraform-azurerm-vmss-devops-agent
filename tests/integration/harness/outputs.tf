output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "Resource group name passed to the example under test."
}

output "location" {
  value       = azurerm_resource_group.this.location
  description = "Resource group location."
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Virtual network name passed to the example under test."
}

output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "Subnet name passed to the example under test."
}

output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "Subnet resource ID."
}

output "azuredevops_project_id" {
  value       = azuredevops_project.this.id
  description = "Azure DevOps project ID."
}

output "azuredevops_project_name" {
  value       = azuredevops_project.this.name
  description = "Azure DevOps project name passed to the example under test."
}

output "azuredevops_service_endpoint_id" {
  value       = azuredevops_serviceendpoint_azurerm.this.id
  description = "Azure DevOps AzureRM service connection ID."
}

output "azuredevops_service_endpoint_name" {
  value       = azuredevops_serviceendpoint_azurerm.this.service_endpoint_name
  description = "Azure DevOps AzureRM service connection name passed to the example under test."
}
