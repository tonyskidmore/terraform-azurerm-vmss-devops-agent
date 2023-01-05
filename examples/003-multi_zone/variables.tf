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

variable "ado_pool_desired_idle" {
  type        = number
  description = "Number of machines to have ready waiting for jobs"
}

variable "ado_pool_max_capacity" {
  type        = number
  description = "Maximum number of machines that will exist in the elastic pool"
}

variable "ado_pool_ttl_mins" {
  type        = number
  description = "The minimum time in minutes to keep idle agents alive"
}

variable "vmss_name" {
  type        = string
  description = "Name of the Virtual Machine Scale Set to create"
}

variable "vmss_resource_group_name" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
}

variable "vmss_sku" {
  type        = string
  description = "Azure Virtual Machine Scale Set SKU"
  default     = "Standard_B1s"
}

variable "vmss_subnet_name" {
  type        = string
  description = "Name of subnet where the vmss will be connected"
}

variable "vmss_vnet_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
}

variable "vmss_zones" {
  type        = list(string)
  description = "A collection of availability zones to spread the Virtual Machines over"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}
