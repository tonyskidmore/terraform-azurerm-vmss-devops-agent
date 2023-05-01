# Azure Virtual Machine Scale Set

In this example we are creating a pool named `vmss-agent-pool-linux-005` based on an Azure MarketPlace Ubuntu 20.04 image.

This example adds additional packages in addition to the Docker CE package.  The cloud-init configuration (cloud-init.tpl) configures these additional packages.  This might be useful if you want a few additional popular packages installed but you do not want to go to the trouble of creating a custom image.

Deploy the agent pool by running the pipeline `005-additional-packages-terraform` created by the `demo_environment`.  Then use the `005-additional-packages-host-test` pipeline to check the deployment.

The `demo_environment` pipelines are documented below.

| Pipeline                          | Description                                                                              |
|-----------------------------------|------------------------------------------------------------------------------------------|
| 005-additional-packages-terraform | create/destroy the `vmss-agent-pool-linux-005` agent pool/VMSS                           |
| 005-additional-packages-host-test | runs test jobs on the host to validate the additional packages                           |


_Note_:
If using the `demo_environment`, to keep costs down ensure that after running and testing that you run `005-additional-packages-terraform` pipeline and choose the `terraform-destroy` parameter option.


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
| ado\_pool\_desired\_idle | Number of machines to have ready waiting for jobs | `number` | n/a | yes |
| ado\_pool\_name | Azure DevOps agent pool name | `string` | n/a | yes |
| ado\_project | Azure DevOps organization | `string` | n/a | yes |
| ado\_service\_connection | Azure DevOps organiservice connection name | `string` | n/a | yes |
| tags | Map of the tags to use for the resources that are deployed | `map(string)` | `{}` | no |
| vmss\_admin\_password | Password to allocate to the admin user account | `string` | n/a | yes |
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
locals {
  vmss_custom_data_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {}))
}

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
  ado_pool_desired_idle    = var.ado_pool_desired_idle
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = data.azurerm_subnet.agents.id
  vmss_custom_data_data    = local.vmss_custom_data_data
  tags                     = var.tags
}
```
<!-- END_TF_DOCS -->
