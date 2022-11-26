resource "azurerm_resource_group" "demo-vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.demo-vmss.id
  lock_level = "CanNotDelete"
  notes      = "This would normally be set if not a demo"
}

provider "shell" {
  sensitive_environment = {
    AZURE_DEVOPS_EXT_PAT = var.ado_ext_pat
  }
}

module "terraform-azurerm-vmss-devops-agent" {
  # TODO: update module path
  # source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  # version                  = "0.1.0"
  source                   = "../"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = azuredevops_project.project.name
  ado_project_only         = "True"
  ado_service_connection   = azuredevops_serviceendpoint_azurerm.sub.service_endpoint_name
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = azurerm_resource_group.demo-vmss.name
  vmss_subnet_id           = azurerm_subnet.demo-vmss.id
}
