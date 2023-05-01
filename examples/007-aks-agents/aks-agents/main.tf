provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

module "terraform-kubernetes-azure-devops-agent" {
  source      = "tonyskidmore/azure-devops-agent/kubernetes"
  version     = "0.0.4"
  ado_ext_pat = var.ado_ext_pat
  ado_org     = var.ado_org
}
