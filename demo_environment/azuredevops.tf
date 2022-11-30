resource "random_string" "build_index" {
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
  path       = each.value.path

  repository {
    repo_type = "TfsGit"
    repo_id   = azuredevops_git_repository.repository[each.value.repo_ref].id
    # branch_name = azuredevops_git_repository.repository[each.value.repo_ref].default_branch
    # TODO: "refs/heads/main"
    branch_name = "refs/heads/examples"
    yml_path    = each.value.yml_path
  }
}

#resource "null_resource" "pipeline-perm-plan-speculative" {
#  triggers = {
#    id = azuredevops_build_definition.build_definition["pipeline2"].id
#  }
#
#  provisioner "local-exec" {
#    command = <<EOF
#id=${azuredevops_build_definition.build_definition["pipeline2"].id}
#payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
#echo $id
#echo $payload
#curl \
#  -u :$AZDO_PERSONAL_ACCESS_TOKEN \
#  -H "Content-Type: application/json" \
#  --request PATCH \
#  --data "$payload" \
#  $AZDO_ORG_SERVICE_URL/${azuredevops_project.project.project_name}/_apis/pipelines/pipelinePermissions/repository/${azuredevops_git_repository.pipeline.project_id}.${azuredevops_git_repository.pipeline.id}?api-version=5.1-preview.1 | jq .
#EOF
#  }
#}

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

resource "azuredevops_environment" "demo" {
  project_id  = azuredevops_project.project.id
  name        = "demo"
  description = "Demo environment"
}

# https://github.com/microsoft/terraform-provider-azuredevops/issues/451
# https://github.com/Mastercard/terraform-provider-restapi
# https://stackoverflow.com/questions/72557511/how-to-add-update-approvers-for-environments-through-rest-api-on-azure-devops

resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "build"
  description  = "Build variables"
  allow_access = true

  variable {
    name  = "build_index"
    value = random_string.build_index.result
  }

  variable {
    name  = "project"
    value = var.ado_project_name
  }

  variable {
    name  = "org"
    value = var.ado_org
  }

  variable {
    name         = "serviceprincipalid"
    secret_value = var.serviceprincipalid
    is_secret    = true
  }

  variable {
    name         = "serviceprincipalkey"
    secret_value = var.serviceprincipalkey
    is_secret    = true
  }

  variable {
    name         = "azurerm_spn_tenantid"
    secret_value = var.azurerm_spn_tenantid
    is_secret    = true
  }

  variable {
    name         = "azurerm_subscription_id"
    secret_value = var.azurerm_subscription_id
    is_secret    = true
  }
}
