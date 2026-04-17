locals {
  vmss_custom_data_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {}))
}

data "azurerm_subnet" "agents" {
  name                 = var.vmss_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

data "azuredevops_project" "pool" {
  name = var.azuredevops_project_name
}

data "azuredevops_serviceendpoint_azurerm" "pool" {
  project_id            = data.azuredevops_project.pool.id
  service_endpoint_name = var.azuredevops_service_endpoint_name
}

module "terraform-azurerm-vmss-devops-agent" {
  source                              = "../../"
  elastic_pool_name                   = var.elastic_pool_name
  elastic_pool_project_id             = data.azuredevops_project.pool.id
  elastic_pool_desired_idle           = var.elastic_pool_desired_idle
  elastic_pool_service_endpoint_id    = data.azuredevops_serviceendpoint_azurerm.pool.id
  elastic_pool_service_endpoint_scope = data.azuredevops_project.pool.id
  vmss_admin_password                 = var.vmss_admin_password
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = var.vmss_resource_group_name
  vmss_subnet_id                      = data.azurerm_subnet.agents.id
  vmss_custom_data_data               = local.vmss_custom_data_data
  vmss_identity = {
    type = "SystemAssigned"
  }
  tags = var.tags
}

data "azurerm_resource_group" "demo" {
  name = "rg-demo-azure-devops-vmss"
}

resource "azurerm_role_assignment" "demo" {
  count                = tobool(lower(var.rbac)) ? 1 : 0
  scope                = data.azurerm_resource_group.demo.id
  role_definition_name = "Reader"
  principal_id         = module.terraform-azurerm-vmss-devops-agent.vmss_identity.principal_id
}
