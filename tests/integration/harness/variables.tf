variable "location" {
  type        = string
  description = "Azure region for the harness resources."
  default     = "uksouth"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group created by the harness."
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network created by the harness."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the harness virtual network."
  default     = ["192.168.0.0/24"]
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet created by the harness."
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the harness subnet."
  default     = ["192.168.0.0/29"]
}

variable "azuredevops_project_name" {
  type        = string
  description = "Name of the Azure DevOps project created by the harness."
}

variable "azuredevops_project_description" {
  type        = string
  description = "Description applied to the Azure DevOps project."
  default     = "Ephemeral project created by terraform-azurerm-vmss-devops-agent integration tests."
}

variable "azuredevops_service_endpoint_name" {
  type        = string
  description = "Name of the Azure DevOps AzureRM service connection created by the harness."
}

variable "azurerm_subscription_name" {
  type        = string
  description = "Display name for the AzureRM service connection."
  default     = "integration-test"
}

variable "serviceprincipalid" {
  type        = string
  description = "Service principal (client) ID used to authenticate the AzureRM service connection."
  sensitive   = true
}

variable "serviceprincipalkey" {
  type        = string
  description = "Service principal client secret used to authenticate the AzureRM service connection."
  sensitive   = true
}

variable "azurerm_spn_tenantid" {
  type        = string
  description = "Azure tenant ID for the service principal used by the service connection."
}

variable "azurerm_subscription_id" {
  type        = string
  description = "Azure subscription ID targeted by the AzureRM service connection."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Azure resources."
  default = {
    environment = "tftest"
    project     = "vmss-devops-agent"
  }
}
