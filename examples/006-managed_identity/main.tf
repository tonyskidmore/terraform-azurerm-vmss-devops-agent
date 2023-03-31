locals {
  vmss_custom_data_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {}))
}

provider "azurerm" {
  features {}
}

provider "shell" {
  sensitive_environment = {
    AZURE_DEVOPS_EXT_PAT = var.ado_ext_pat
  }
}

data "azurerm_subnet" "agents" {
  name                 = var.vmss_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

module "terraform-azurerm-vmss-devops-agent" {
  source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  version                  = "0.2.2"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = var.ado_project
  ado_service_connection   = var.ado_service_connection
  ado_pool_desired_idle    = var.ado_pool_desired_idle
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = data.azurerm_subnet.agents.id
  vmss_custom_data_data    = local.vmss_custom_data_data
  vmss_identity_type       = "SystemAssigned"
  tags                     = var.tags
}

data "azurerm_resource_group" "demo" {
  name = "rg-demo-azure-devops-vmss"
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_resource_group.demo.id
  role_definition_name = "Reader"
  principal_id         = module.terraform-azurerm-vmss-devops-agent.vmss_identity_principal_id
}
