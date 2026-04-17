variable "azuredevops_project_name" {
  type        = string
  description = "Azure DevOps project name that owns the agent pool queue and AzureRM service connection."
}

variable "azuredevops_service_endpoint_name" {
  type        = string
  description = "Azure DevOps AzureRM service connection name."
}

variable "elastic_pool_name" {
  type        = string
  description = "Azure DevOps VM scale set agent pool name."
}

variable "elastic_pool_desired_idle" {
  type        = number
  description = "Number of machines to have ready waiting for jobs."
}

variable "vmss_name" {
  type        = string
  description = "Name of the Virtual Machine Scale Set to create"
}

variable "vmss_resource_group_name" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
}

variable "vmss_subnet_name" {
  type        = string
  description = "Name of subnet where the vmss will be connected"
}

variable "vmss_vnet_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
}

variable "vmss_admin_password" {
  type        = string
  description = "Password to allocate to the admin user account"
}

variable "rbac" {
  type        = string
  description = "Whether to create the Reader role assignment for the system-assigned identity."
  default     = "false"
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}
