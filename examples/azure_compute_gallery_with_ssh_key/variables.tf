variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps personal access token"
}

variable "vm_image_version" {
  type        = string
  description = "Azure Compute Gallery VM image version"
  default     = "1.0.17"
}

variable "vm_image_version_path" {
  type        = string
  description = "Azure Compute Gallery VM image versions resource ID path"
  default     = "resourceGroups/rg-ve-acg-01/providers/Microsoft.Compute/galleries/acg_01/images/ubuntu20/versions"
}
