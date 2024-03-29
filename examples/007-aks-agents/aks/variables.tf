variable "resource_group_name" {
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

variable "cluster_name" {
  type        = string
  description = "AKS cluster name"
}

variable "rbac_aad" {
  type        = bool
  description = "AKS AAD RBAC"
  default     = false
}

variable "private_cluster_enabled" {
  type        = bool
  description = "AKS Private Cluster"
  default     = true
}

variable "log_analytics_workspace_enabled" {
  type        = bool
  description = "AKS log analytics workspace enabled"
  default     = false
}
