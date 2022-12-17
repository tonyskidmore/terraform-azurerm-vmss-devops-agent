
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.3.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">=3.4.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "~>1.7.10"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">=1.18.0"
    }
    null = {
      version = ">= 3.2.1"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

provider "restapi" {
  alias = "restapi_headers"
  uri   = var.ado_org
  debug = true
  # write_returns_object = true
  create_returns_object = "true"
  # username             = "dummy"
  # password             = var.ado_ext_pat

  headers = {
    Content-Type  = "application/json",
    Authorization = "Basic ${base64encode(":${var.ado_ext_pat}")}"
    # Accept        = "application/json;api-version=7.1-preview.4"
  }
}
