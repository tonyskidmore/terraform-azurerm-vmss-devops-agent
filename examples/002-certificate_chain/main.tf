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

resource "tls_private_key" "vmss_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "terraform-azurerm-vmss-devops-agent" {
  source                     = "tonyskidmore/vmss-devops-agent/azurerm"
  version                    = "0.2.4"
  ado_org                    = var.ado_org
  ado_pool_name              = var.ado_pool_name
  ado_project                = var.ado_project
  ado_pool_recycle_after_use = true
  ado_service_connection     = var.ado_service_connection
  vmss_ssh_public_key        = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                  = var.vmss_name
  vmss_resource_group_name   = var.vmss_resource_group_name
  vmss_subnet_id             = data.azurerm_subnet.agents.id
  tags                       = var.tags
  vmss_custom_data_data      = local.vmss_custom_data_data
  vmss_source_image_offer    = var.vmss_source_image_offer
  vmss_source_image_sku      = var.vmss_source_image_sku
}
