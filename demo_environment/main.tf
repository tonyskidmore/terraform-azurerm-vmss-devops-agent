resource "azurerm_resource_group" "demo-vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# resource "azurerm_management_lock" "resource-group-level" {
#   name       = "resource-group-level"
#   scope      = azurerm_resource_group.demo-vmss.id
#   lock_level = "CanNotDelete"
#   notes      = "This would normally be set if not a demo"
# }

module "terraform-azurerm-vmss-devops-agent" {
  # source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  # version                  = "0.1.0"
  source                              = "../"
  elastic_pool_name                   = var.ado_pool_name
  elastic_pool_project_id             = azuredevops_project.project.id
  elastic_pool_service_endpoint_id    = azuredevops_serviceendpoint_azurerm.sub.id
  elastic_pool_service_endpoint_scope = azuredevops_project.project.id
  vmss_admin_password                 = var.vmss_admin_password
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = azurerm_resource_group.demo-vmss.name
  vmss_subnet_id                      = azurerm_subnet.demo-vmss.id
  vmss_custom_data_data               = local.vmss_custom_data_data
  vmss_identity_type                  = "SystemAssigned"
}
