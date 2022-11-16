resource "azuredevops_project" "project" {
  name        = "demo-vmss"
  description = "VMMS agent demo project"
}

# resource "azuredevops_git_repository" "repository" {
#   project_id     = azuredevops_project.project.id
#   name           = "vmss-demo"
#   default_branch = "refs/heads/main"
#   initialization {
#     init_type = "Clean"
#   }
#   lifecycle {
#     ignore_changes = [
#       # Ignore changes to initialization to support importing existing repositories
#       # Given that a repo now exists, either imported into terraform state or created by terraform,
#       # we don't care for the configuration of initialization against the existing resource
#       initialization,
#     ]
#   }
# }

resource "azuredevops_git_repository" "repository" {
  project_id     = azuredevops_project.project.id
  name           = "Example Import Repository"
  default_branch = "refs/heads/main"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/tonyskidmore/azure-pipelines-yaml.git"
  }
}

# resource "azuredevops_git_repository_file" "pipeline" {
#   repository_id       = azuredevops_git_repository.repository.id
#   file                = "azure-pipelines.yml"
#   content             = file("./azure-pipelines.yml")
#   branch              = "refs/heads/main"
#   commit_message      = "First commit"
#   overwrite_on_create = false
# }

resource "azuredevops_build_definition" "build_definition" {
  project_id = azuredevops_project.project.id
  name       = "demo-vmss-pipeline"
  path       = "\\"

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = azuredevops_git_repository.repository.default_branch
    yml_path    = "azure-pipelines.yml"
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
