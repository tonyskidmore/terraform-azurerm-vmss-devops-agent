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

resource "tls_private_key" "vmss_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "terraform-azurerm-vmss-devops-agent" {
  source                              = "../../"
  elastic_pool_name                   = var.elastic_pool_name
  elastic_pool_project_id             = data.azuredevops_project.pool.id
  elastic_pool_recycle_after_each_use = true
  elastic_pool_service_endpoint_id    = data.azuredevops_serviceendpoint_azurerm.pool.id
  elastic_pool_service_endpoint_scope = data.azuredevops_project.pool.id
  vmss_ssh_public_key                 = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = var.vmss_resource_group_name
  vmss_subnet_id                      = data.azurerm_subnet.agents.id
  tags                                = var.tags
  vmss_custom_data_data               = local.vmss_custom_data_data
  vmss_source_image_offer             = var.vmss_source_image_offer
  vmss_source_image_sku               = var.vmss_source_image_sku
}
