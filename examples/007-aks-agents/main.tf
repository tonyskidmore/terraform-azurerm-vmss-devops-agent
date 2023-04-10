
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

module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "6.8.0"
  prefix              = "prefix-${random_id.prefix.hex}"
  resource_group_name = var.vmss_resource_group_name
  cluster_name        = "test-cluster"
  node_resource_group = var.node_resource_group
  vnet_subnet_id      = data.azurerm_subnet.agents.id
}


module "terraform-azurerm-aks-devops-agent" {
  source              = "tonyskidmore/aks-devops-agent/azurerm"
  version             = "0.0.2"
  ado_ext_pat         = var.ado_ext_pat
  ado_org             = var.ado_org
  prefix              = "prefix-${random_id.prefix.hex}"
  resource_group_name = var.vmss_resource_group_name

  cluster_name = module.aks.aks_name
  # node_resource_group = var.node_resource_group
  # net_profile_dns_service_ip     = "10.0.0.10"
  # net_profile_docker_bridge_cidr = "170.10.0.1/16"
  # https://learn.microsoft.com/en-us/azure/aks/egress-outboundtype
  # https://learn.microsoft.com/en-us/azure/aks/nat-gateway
  # https://www.thorsten-hans.com/provision-aks-and-nat-gateway-with-terraform/
  # net_profile_outbound_type = "userAssignedNATGateway"
  # net_profile_service_cidr = "10.0.0.0/16"
  # network_plugin           = "azure"
  # network_policy           = "azure"
  # vnet_subnet_id = data.azurerm_subnet.agents.id
}

# data "azurerm_resource_group" "demo" {
#   name = var.vmss_resource_group_name
# }
