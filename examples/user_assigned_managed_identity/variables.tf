variable "ado_ext_pat" {
  type        = string
  description = "Azure DevOps personal access token"
}

variable "user_assigned_identity_count" {
  type        = number
  description = "The number of user assigned identities to create"
  default     = 1
}
