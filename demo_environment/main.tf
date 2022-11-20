# create azure resources

resource "azurerm_resource_group" "demo-vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "demo-vmss" {
  name                = var.vmss_vnet_name
  resource_group_name = azurerm_resource_group.demo-vmss.name
  address_space       = var.vmss_vnet_address_space
  location            = azurerm_resource_group.demo-vmss.location
  tags                = var.tags
}

resource "azurerm_subnet" "demo-vmss" {
  name                 = var.vmss_subnet_name
  resource_group_name  = azurerm_resource_group.demo-vmss.name
  address_prefixes     = var.vmss_subnet_address_prefixes
  virtual_network_name = azurerm_virtual_network.demo-vmss.name
}

resource "azurerm_network_security_group" "demo-vmss" {
  name                = var.nsg_name
  location            = azurerm_resource_group.demo-vmss.location
  resource_group_name = azurerm_resource_group.demo-vmss.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "demo-vmss" {
  subnet_id                 = azurerm_subnet.demo-vmss.id
  network_security_group_id = azurerm_network_security_group.demo-vmss.id
}

resource "azurerm_storage_account" "demo-vmss" {
  name                     = "sademovmss${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.demo-vmss.name
  location                 = azurerm_resource_group.demo-vmss.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # public_network_access_enabled = false
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.demo-vmss.name
  # container_access_type = "container"
  container_access_type = "private"
}



# azure devops project

resource "random_string" "random" {
  length      = 6
  min_numeric = 6
}

resource "azuredevops_project" "project" {
  name        = var.ado_project_name
  description = var.ado_project_description
}

resource "azuredevops_git_repository" "repository" {
  for_each   = var.git_repos
  project_id = azuredevops_project.project.id
  name       = each.value.name
  # default_branch = each.value.default_branch
  default_branch = "refs/heads/main"
  initialization {
    init_type   = each.value.initialization.init_type
    source_type = each.value.initialization.source_type
    source_url  = each.value.initialization.source_url
  }
}

resource "azuredevops_build_definition" "build_definition" {
  for_each = var.build_definitions

  project_id = azuredevops_project.project.id
  name       = each.value.name
  path       = "\\"

  repository {
    repo_type = "TfsGit"
    repo_id   = azuredevops_git_repository.repository[each.value.repo_ref].id
    # branch_name = azuredevops_git_repository.repository[each.value.repo_ref].default_branch
    branch_name = "refs/heads/main"
    yml_path    = each.value.yml_path
  }
}

resource "azuredevops_serviceendpoint_azurerm" "sub" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.service_endpoint_name
  description           = "Managed by Terraform"
  credentials {
    serviceprincipalid  = var.serviceprincipalid
    serviceprincipalkey = var.serviceprincipalkey
  }
  azurerm_spn_tenantid      = var.azurerm_spn_tenantid
  azurerm_subscription_id   = var.azurerm_subscription_id
  azurerm_subscription_name = var.azurerm_subscription_name
}

resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "build"
  description  = "Build variables"
  allow_access = true

  variable {
    name  = "build_index"
    value = random_string.random.result
  }

}

# bootstrap vmss devops pool

provider "shell" {
  sensitive_environment = {
    AZURE_DEVOPS_EXT_PAT = var.ado_ext_pat
  }
}

module "terraform-azurerm-vmss-devops-agent" {
  # TODO: update module path
  # source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  # version                  = "0.1.0"
  source                   = "../"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = azuredevops_project.project.name
  ado_project_only         = "True"
  ado_service_connection   = azuredevops_serviceendpoint_azurerm.sub.service_endpoint_name
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = azurerm_resource_group.demo-vmss.name
  vmss_subnet_id           = azurerm_subnet.demo-vmss.id
}