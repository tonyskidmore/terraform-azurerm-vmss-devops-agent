
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.3.0"
    }
    random = {
        source = "registry.terraform.io/hashicorp/random"
        version = ">=3.4.0"
    }
  }
  required_version = ">= 1.0.0"
}
