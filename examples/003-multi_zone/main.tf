provider "azurerm" {
  features {}
}

provider "azuredevops" {}

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

locals {
  vmss_user_data = base64encode(jsonencode({ "hello" = "world" }))
}

module "terraform-azurerm-vmss-devops-agent" {
  source                              = "../../"
  elastic_pool_name                   = var.elastic_pool_name
  elastic_pool_project_id             = data.azuredevops_project.pool.id
  elastic_pool_desired_idle           = var.elastic_pool_desired_idle
  elastic_pool_max_capacity           = var.elastic_pool_max_capacity
  elastic_pool_service_endpoint_id    = data.azuredevops_serviceendpoint_azurerm.pool.id
  elastic_pool_service_endpoint_scope = data.azuredevops_project.pool.id
  elastic_pool_time_to_live_minutes   = var.elastic_pool_time_to_live_minutes
  vmss_ssh_public_key                 = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = var.vmss_resource_group_name
  vmss_sku                            = var.vmss_sku
  vmss_subnet_id                      = data.azurerm_subnet.agents.id
  vmss_user_data                      = local.vmss_user_data
  vmss_zones                          = var.vmss_zones
  tags                                = var.tags
}
