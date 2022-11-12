variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps Personal Access Token"
}

variable "ado_org" {
  type        = string
  description = "Azure DevOps organization"
}

variable "ado_project" {
  type        = string
  description = "Azure DevOps organization"
}

variable "ado_service_connection" {
  type        = string
  description = "Azure DevOps organiservice connection name"
}

variable "ado_pool_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
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

variable "vmss_admin_password" {
  type        = string
  description = "Password to allocate to the admin user account"
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default = {
    environment = "test"
    project     = "vmss"
  }
}
