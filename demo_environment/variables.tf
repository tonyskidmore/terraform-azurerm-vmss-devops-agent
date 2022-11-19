variable "ado_project_name" {
  type        = string
  description = "Azure DevOps project name"
  default     = "demo-vmss"
}

variable "ado_project_description" {
  type        = string
  description = "Azure DevOps project description"
  default     = "VMMS agent demo project"
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
