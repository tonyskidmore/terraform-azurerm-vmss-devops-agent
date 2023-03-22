resource "random_string" "build_index" {
  length      = 6
  min_numeric = 6
}

resource "azuredevops_project" "project" {
  name        = var.ado_project_name
  description = var.ado_project_description
  visibility  = var.ado_project_visibility
}

resource "azuredevops_git_repository" "repository" {
  for_each       = var.git_repos
  project_id     = azuredevops_project.project.id
  name           = each.value.name
  default_branch = "refs/heads/main"
  initialization {
    init_type   = each.value.initialization.init_type
    source_type = each.value.initialization.source_type
    source_url  = each.value.initialization.source_url
  }
}


# TODO:
# pending: https://github.com/microsoft/terraform-provider-azuredevops/issues/668

# data "azuredevops_group" "build_service" {
#   name = "Project Collection Build Service Accounts"
# }
#
# resource "azuredevops_git_permissions" "repo-permissions" {
#   for_each      = azuredevops_git_repository.repository
#   project_id    = azuredevops_project.project.id
#   repository_id = each.value.id
#   principal     = data.azuredevops_group.build_service.id
#   permissions = {
#     GenericContribute = "Allow"
#     PolicyExempt      = "Allow"
#   }
# }

resource "azuredevops_build_definition" "build_definition" {
  for_each = var.build_definitions

  project_id = azuredevops_project.project.id
  name       = each.value.name
  path       = each.value.path

  repository {
    repo_type   = "TfsGit"
    branch_name = "main"
    repo_id     = azuredevops_git_repository.repository[each.value.repo_ref].id
    yml_path    = each.value.yml_path
  }

  depends_on = [
    azuredevops_git_repository.repository
  ]
}


# add permissions to repo for pipeline
resource "null_resource" "build_definition_pipelines_repo_perms" {
  for_each = azuredevops_build_definition.build_definition
  triggers = {
    id = each.value.id
  }

  depends_on = [
    azuredevops_build_definition.build_definition,
    azuredevops_git_repository.repository
  ]

  provisioner "local-exec" {
    command = <<EOF
id=${each.value.id}
payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
echo $id
echo $payload
curl \
  --silent \
  --show-error \
  --user ":$AZDO_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data "$payload" \
  "$AZDO_ORG_SERVICE_URL/${var.ado_project_name}/_apis/pipelines/pipelinePermissions/repository/${azuredevops_project.project.id}.${azuredevops_git_repository.repository["repo2"].id}?api-version=7.0-preview.1" | jq .
EOF
  }
}


# │ Error: error creating resource Build Definition: TF400898: An Internal Error Occurred. Activity Id: c01eeedf-9914-4566-b7a5-68139ca06bf1.
# │
# │   with azuredevops_build_definition.build_definition["pipeline11"],
# │   on azuredevops.tf line 43, in resource "azuredevops_build_definition" "build_definition":
# │   43: resource "azuredevops_build_definition" "build_definition" {

# resource "null_resource" "build_definition_module_repo_perms" {
#   for_each = azuredevops_build_definition.build_definition
#   triggers = {
#     id = each.value.id
#   }

#   depends_on = [
#     azuredevops_build_definition.build_definition,
#     azuredevops_git_repository.repository,
#     null_resource.build_definition_pipelines_repo_perms
#   ]

#   provisioner "local-exec" {
#     command = <<EOF
# id=${each.value.id}
# payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
# echo $id
# echo $payload
# curl \
#   --silent \
#   --show-error \
#   --user ":$AZDO_PERSONAL_ACCESS_TOKEN" \
#   --header "Content-Type: application/json" \
#   --request PATCH \
#   --data "$payload" \
#   "$AZDO_ORG_SERVICE_URL/${var.ado_project_name}/_apis/pipelines/pipelinePermissions/repository/${azuredevops_project.project.id}.${azuredevops_git_repository.repository["repo1"].id}?api-version=7.0-preview.1" | jq .
# EOF
#   }
# }


resource "azuredevops_environment" "demo" {
  project_id  = azuredevops_project.project.id
  name        = "demo"
  description = "Demo environment"
}

# add permissions to environment for pipeline
resource "null_resource" "build_definition_env_perms" {
  for_each = azuredevops_build_definition.build_definition
  triggers = {
    id = each.value.id
  }

  depends_on = [
    azuredevops_build_definition.build_definition,
    azuredevops_environment.demo
  ]

  provisioner "local-exec" {
    command = <<EOF
id=${each.value.id}
payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
echo $id
echo $payload
curl \
  --silent \
  --show-error \
  --user ":$AZDO_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data "$payload" \
  "$AZDO_ORG_SERVICE_URL/${var.ado_project_name}/_apis/pipelines/pipelinePermissions/environment/${azuredevops_environment.demo.id}?api-version=7.1-preview.1" | jq .
EOF
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

resource "azuredevops_resource_authorization" "azurerm" {
  for_each    = azuredevops_build_definition.build_definition
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.sub.id
  # definition_id = azuredevops_build_definition.build_definition["pipeline2"].id
  definition_id = each.value.id
  authorized    = true
}


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
    name  = "ado_org"
    value = var.ado_org
  }

  variable {
    name         = "ado_ext_pat"
    secret_value = var.ado_ext_pat
    is_secret    = true
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

  variable {
    name  = "state_resource_group_name"
    value = azurerm_resource_group.demo-vmss.name
  }

  variable {
    name  = "state_storage_account_name"
    value = azurerm_storage_account.demo-vmss.name
  }

  variable {
    name  = "state_container_name"
    value = azurerm_storage_container.tfstate.name
  }

}
