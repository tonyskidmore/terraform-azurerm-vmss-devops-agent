variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps Personal Access Token"
  sensitive   = true
}

variable "ado_org" {
  type        = string
  description = "Azure DevOps organization"
}

variable "vmss_resource_group_name" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of subnet where the vmss will be connected"
}

variable "vmss_vnet_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
}

variable "node_resource_group" {
  type        = string
  description = "Resource group name for the AKS cluster"
}
