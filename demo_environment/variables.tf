variable "ado_org" {
  type        = string
  description = "Azure DevOps organization"
}

variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps Personal Access Token"
}

variable "ado_project_name" {
  type        = string
  description = "Azure DevOps project name"
  default     = "demo-vmss"
}

variable "ado_project_visibility" {
  type        = string
  description = "Azure DevOps project visibility"
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.ado_project_visibility)
    error_message = "The ado_project_visibility variable must be public or private."
  }
}

variable "ado_pool_name" {
  type        = string
  description = "Azure DevOps agent pool name"
}

variable "ado_project_description" {
  type        = string
  description = "Azure DevOps project description"
  default     = "VMMS agent demo project"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name of where all resources will be created"
}

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

variable "build_definitions" {
  type = map(object({
    name     = string
    path     = string
    repo_ref = string
    yml_path = string
  }))
  description = "Pipelines to create"
}

variable "git_repos" {
  type = map(object({
    name = string
    # default_branch = string
    initialization = map(string)
  }))
  description = "Repos to create"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}

variable "vmss_admin_password" {
  type        = string
  description = "Password to allocate to the admin user account"
}

variable "vmss_subnet_name" {
  type        = string
  description = "Name of subnet where the vmss will be connected"
}

variable "vmss_subnet_address_prefixes" {
  type        = list(string)
  description = "Subnet address prefixes"
}

variable "vmss_vnet_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
}

variable "vmss_vnet_address_space" {
  type        = list(string)
  description = "Vnet network address spaces"
}

variable "vmss_name" {
  type        = string
  description = "Name of the Virtual Machine Scale Set to create"
}
