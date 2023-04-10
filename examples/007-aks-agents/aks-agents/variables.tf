variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps Personal Access Token"
  sensitive   = true
}

variable "ado_org" {
  type        = string
  description = "Azure DevOps organization"
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name"
}
