variable "service_endpoint_name" {
  type        = string
  description = "AzureRM service connection name"
  default     = "demo-vmss"
}

variable "serviceprincipalid" {
  type        = string
  description = "Service principal ID"
}

variable "serviceprincipalkey" {
  type        = string
  description = "Service principal secret"
}

variable "azurerm_spn_tenantid" {
  type        = string
  description = "Azure Tenant ID of the service principal"
}

variable "azurerm_subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "azurerm_subscription_name" {
  type        = string
  description = "Azure subscription name"
  default     = "Azure subscription 1"
}
