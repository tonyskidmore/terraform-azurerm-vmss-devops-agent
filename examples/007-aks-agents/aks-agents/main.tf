
provider "azurerm" {
  features {}
}

# resource "random_id" "prefix" {
#   byte_length = 8
# }

# data "azurerm_subnet" "agents" {
#   name                 = var.aks_subnet_name
#   resource_group_name  = var.vmss_resource_group_name
#   virtual_network_name = var.vmss_vnet_name
# }

# module "aks" {
#   source              = "Azure/aks/azurerm"
#   version             = "6.8.0"
#   prefix              = "prefix-${random_id.prefix.hex}"
#   resource_group_name = var.vmss_resource_group_name
#   cluster_name        = "test-cluster"
#   node_resource_group = var.node_resource_group
#   vnet_subnet_id      = data.azurerm_subnet.agents.id
# }

data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

module "terraform-azurerm-aks-devops-agent" {
  source      = "tonyskidmore/azure-devops-agent/kubernetes"
  version     = "0.0.3"
  ado_ext_pat = var.ado_ext_pat
  ado_org     = var.ado_org
  # resource_group_name = var.vmss_resource_group_name
  # cluster_name        = module.aks.aks_name
}
