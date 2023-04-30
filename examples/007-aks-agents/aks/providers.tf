terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0, < 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">=3.4.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
  backend "azurerm" {}
}

# https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/aks/main.tf

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.default.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate)
  }
}
