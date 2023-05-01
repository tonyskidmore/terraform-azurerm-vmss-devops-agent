# Azure Virtual Machine Scale Set

Example of creating an Azure VMSS and associated Azure DevOps agent pool.
In this case we are using the most basic configuration, supplying an administrator password
to keep the example as simple as possible.  `vmss_custom_data_script` variable defaults to `null`
so no cloud-init configuration will be applied.

Example steps to test the module locally (for example in Windows Subsystem for Linux):

````bash

# authenticate Terraform to Azure - replace values with your tenant, subscription and service principal values
 export ARM_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
 export ARM_TENANT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_SECRET=<secret-here>

# authenticate to Azure DevOps with Personal Access Token
 export AZDO_PERSONAL_ACCESS_TOKEN="<pat-here>"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/tonyskidmore" # your organization here

# reference the above to pass into Terraform
export TF_VAR_ado_org="$AZDO_ORG_SERVICE_URL"
export TF_VAR_ado_ext_pat="$AZDO_PERSONAL_ACCESS_TOKEN"
export TF_VAR_serviceprincipalid="$ARM_CLIENT_ID"
export TF_VAR_serviceprincipalkey="$ARM_CLIENT_SECRET"
export TF_VAR_azurerm_spn_tenantid="$ARM_TENANT_ID"
export TF_VAR_azurerm_subscription_id="$ARM_SUBSCRIPTION_ID"

git clone https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent.git

cd examples/001-admin_password
terraform init
terraform plan -out tfplan
terraform apply tfplan

````

To use this example update the `terraform.tfvars` file to match your Azure requirements and your Azure DevOps setup.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >=3.1.0 |
| shell | ~>1.7.10 |
## Providers

| Name | Version |
|------|---------|
| azurerm | 3.54.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| terraform-azurerm-vmss-devops-agent | tonyskidmore/vmss-devops-agent/azurerm | 0.2.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ado\_ext\_pat | Azure DevOps Personal Access Token | `string` | n/a | yes |
| ado\_org | Azure DevOps organization | `string` | n/a | yes |
| ado\_pool\_name | Azure DevOps agent pool name | `string` | n/a | yes |
| ado\_project | Azure DevOps organization | `string` | n/a | yes |
| ado\_service\_connection | Azure DevOps organiservice connection name | `string` | n/a | yes |
| tags | Map of the tags to use for the resources that are deployed | `map(string)` | `{}` | no |
| vmss\_admin\_password | Password to allocate to the admin user account | `string` | n/a | yes |
| vmss\_custom\_data\_script | The path to the script that will be base64 encoded custom data for the VMSS instances | `string` | `null` | no |
| vmss\_name | Name of the Virtual Machine Scale Set to create | `string` | n/a | yes |
| vmss\_resource\_group\_name | Existing resource group name of where the VMSS will be created | `string` | n/a | yes |
| vmss\_subnet\_name | Name of subnet where the vmss will be connected | `string` | n/a | yes |
| vmss\_vnet\_name | Name of the Vnet that the target subnet is a member of | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| vmss\_id | Virtual Machine Scale Set ID |

Example

```hcl
provider "azurerm" {
  features {}
}

provider "shell" {
  sensitive_environment = {
    AZURE_DEVOPS_EXT_PAT = var.ado_ext_pat
  }
}

data "azurerm_subnet" "agents" {
  name                 = var.vmss_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

module "terraform-azurerm-vmss-devops-agent" {
  source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  version                  = "0.2.5"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = var.ado_project
  ado_service_connection   = var.ado_service_connection
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = data.azurerm_subnet.agents.id
  vmss_custom_data_script  = var.vmss_custom_data_script
  tags                     = var.tags
}
```
<!-- END_TF_DOCS -->
