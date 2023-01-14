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
  description = "Azure DevOps agent pool name"
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

variable "vmss_data_disks" {
  type = list(object({
    caching              = string
    create_option        = string
    disk_size_gb         = string
    lun                  = number
    storage_account_type = string
  }))
  description = "Additional data disks"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}
