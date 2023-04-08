
provider "azurerm" {
  features {}
}

resource "random_id" "prefix" {
  byte_length = 8
}

data "azurerm_subnet" "agents" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

module "terraform-azurerm-aks-devops-agent" {
  source  = "tonyskidmore/aks-devops-agent/azurerm"
  version = "0.0.1"

  prefix              = "prefix-${random_id.prefix.hex}"
  resource_group_name = data.azurerm_resource_group.demo.name
  vnet_subnet_id      = data.azurerm_subnet.agents.id
  node_resource_group = var.node_resource_group
}

data "azurerm_resource_group" "demo" {
  name = var.vmss_resource_group_name
}
