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

resource "tls_private_key" "vmss_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  vmss_user_data = base64encode(jsonencode({ "hello" = "world" }))
}

module "terraform-azurerm-vmss-devops-agent" {
  source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  version                  = "0.2.6"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = var.ado_project
  ado_service_connection   = var.ado_service_connection
  ado_pool_desired_idle    = var.ado_pool_desired_idle
  ado_pool_max_capacity    = var.ado_pool_max_capacity
  ado_pool_ttl_mins        = var.ado_pool_ttl_mins
  vmss_ssh_public_key      = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                = var.vmss_name
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_sku                 = var.vmss_sku
  vmss_subnet_id           = data.azurerm_subnet.agents.id
  vmss_user_data           = local.vmss_user_data
  vmss_zones               = var.vmss_zones
  tags                     = var.tags
}
