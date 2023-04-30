# Azure Virtual Machine Scale Set

In this example we are creating a pool named `vmss-agent-pool-linux-006` based on an Azure MarketPlace Ubuntu 20.04 image.

The VMSS will be created with a system-assigned
[Managed Identity](https://devblogs.microsoft.com/devops/demystifying-service-principals-managed-identities/)
which will be used to authenticate Terraform to Azure.
Deploy the agent pool by running the pipeline `006-managed-identity-terraform` created by the `demo_environment`.
The VMSS Managed Identity will need to have role assignment in the target subscription or the testing pipelines
will fail with an error.  If the service principal being used for the Azure Resource Manager service connection
has Owner or User Access Administrator role assignment then you can select the `Configure RBAC?` parameter
on the `006-managed-identity-terraform` pipeline to automatically assign `Reader` access to the `rg-demo-azure-devops-vmss`
resource group.  If not then you will need to perform some manual role assignment in the subscription, it doesn't
really matter what that assignment is, as the test pipeline doesn't do much past authenticating to Azure
and using `azurerm_client_config` data source to dump out some output.

Then use the `006-managed-identity-test` and `006-managed-identity-host-test` pipelines to check the deployment.

The `demo_environment` pipelines are documented below.

| Pipeline                        | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| 006-managed-identity-terraform  | create/destroy the `vmss-agent-pool-linux-006` agent pool/VMSS                           |
| 006-managed-identity-test       | runs test container jobs on the the above agent pool/VMSS                                |
| 006-managed-identity-host-test  | runs test jobs on the host, including authenticating Terraform using managed identity    |

The `006-managed-identity-test` consists of two jobs. The first one is just to discover the necessary subscription and tenant IDs.
These are passed onto the second job, which will run on the opposite agent to the first job.
This is just to demonstrate that the second job can authenticate Terraform to Azure purely by using the managed identity and does not
require the Azure Resource Manager service connection created in the demo project.
Normally, you would just pass these IDs into the pipeline by whatever your standard mechanism is.

_Important:_  As per the note above, the VMSS Managed Identity requires some kind of role assignment in the target subscription.

_Note_:
If using the `demo_environment` pipeline it will deploy 2 instances to begin with, which means that cost will be incurred from the time the Scale Set agent is deployed.
To keep costs down ensure that after running and testing that you run `006-managed-identity-terraform` pipeline and choose the `terraform-destroy` parameter option.


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
| terraform-azurerm-vmss-devops-agent | tonyskidmore/vmss-devops-agent/azurerm | 0.2.4 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ado\_ext\_pat | Azure DevOps Personal Access Token | `string` | n/a | yes |
| ado\_org | Azure DevOps organization | `string` | n/a | yes |
| ado\_pool\_desired\_idle | Number of machines to have ready waiting for jobs | `number` | n/a | yes |
| ado\_pool\_name | Azure DevOps agent pool name | `string` | n/a | yes |
| ado\_project | Azure DevOps organization | `string` | n/a | yes |
| ado\_service\_connection | Azure DevOps organiservice connection name | `string` | n/a | yes |
| rbac | Configure RBAC | `string` | `false` | no |
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
  version                  = "0.2.4"
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
  vmss_identity_type       = "SystemAssigned"
  tags                     = var.tags
}

data "azurerm_resource_group" "demo" {
  name = "rg-demo-azure-devops-vmss"
}

resource "azurerm_role_assignment" "demo" {
  count                = tobool(lower(var.rbac)) ? 1 : 0
  scope                = data.azurerm_resource_group.demo.id
  role_definition_name = "Reader"
  principal_id         = module.terraform-azurerm-vmss-devops-agent.vmss_system_assigned_identity_id
}
```
<!-- END_TF_DOCS -->
