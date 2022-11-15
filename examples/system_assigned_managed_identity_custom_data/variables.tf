variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps personal access token"
}

variable "blob_container" {
  type        = string
  description = "Azure storage container"
  default     = "content"
}

variable "blob_name" {
  type        = string
  description = "Azure storage blob path"
  default     = "vmss.txt"
}
