# Azure DevOps Project

This example creates an Azure DevOps project that can be used for the other examples.
Certain environment variables need to be defined prior to running the example.

Azure
Subscription
Contributor + User Access Administrator
or Owner

Azure DevOps
Personal Access Token - Full Access

````bash

# authenticate Terraform to Azure - replace values with your tenant, subscription and service principal values
 export ARM_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
 export ARM_TENANT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_SECRET=AAABjkwhs7862782626_BsGGjkskj_MaGv

 export AZDO_PERSONAL_ACCESS_TOKEN="your PAT here" # full access
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/tonyskidmore" # your organization

export TF_VAR_ado_ext_pat="$AZDO_PERSONAL_ACCESS_TOKEN"
export TF_VAR_serviceprincipalid="$ARM_CLIENT_ID"
export TF_VAR_serviceprincipalkey="$ARM_CLIENT_SECRET"
export TF_VAR_azurerm_spn_tenantid="$ARM_TENANT_ID"
export TF_VAR_azurerm_subscription_id="$ARM_SUBSCRIPTION_ID"

terraform init
terraform plan -out tfplan
terraform apply tfplan

````

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azuredevops | >=0.1.0 |
## Providers

| Name | Version |
|------|---------|
| azuredevops | 0.3.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azurerm\_spn\_tenantid | Azure Tenant ID of the service principal | `string` | n/a | yes |
| azurerm\_subscription\_id | Azure subscription ID | `string` | n/a | yes |
| azurerm\_subscription\_name | Azure subscription name | `string` | `"Azure subscription 1"` | no |
| service\_endpoint\_name | AzureRM service connection name | `string` | `"demo-vmss"` | no |
| serviceprincipalid | Service principal ID | `string` | n/a | yes |
| serviceprincipalkey | Service principal secret | `string` | n/a | yes |
## Outputs

No outputs.

Example

```hcl
resource "azuredevops_project" "project" {
  name        = "demo-vmss"
  description = "VMMS agent demo project"
}

resource "azuredevops_git_repository" "repository" {
  project_id     = azuredevops_project.project.id
  name           = "vmss-demo"
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to initialization to support importing existing repositories
      # Given that a repo now exists, either imported into terraform state or created by terraform,
      # we don't care for the configuration of initialization against the existing resource
      initialization,
    ]
  }
}

resource "azuredevops_git_repository_file" "pipeline" {
  repository_id       = azuredevops_git_repository.repository.id
  file                = "azure-pipelines.yml"
  content             = file("./azure-pipelines.yml")
  branch              = "refs/heads/main"
  commit_message      = "First commit"
  overwrite_on_create = false
}

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
```
<!-- END_TF_DOCS -->
