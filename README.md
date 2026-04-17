# terraform-azurerm-vmss-devops-agent

Terraform module that creates:

- an Azure virtual machine scale set
- an Azure DevOps VM scale set agent pool backed by that VMSS

This module now uses the provider-native
`terraform-azuredevops-azure-devops-elasticpool` replacement instead of the
archived shell-based workaround.

## Requirements

- Terraform `>= 1.5.0`
- `hashicorp/azurerm >= 4.69.0, < 5.0.0`
- `microsoft/azuredevops >= 1.15.0, < 2.0.0`
- An existing Azure DevOps AzureRM service connection
- An Azure DevOps project that owns that service connection

Azure DevOps provider authentication is configured outside the module using the
provider's supported mechanisms such as PAT, service principal, OIDC, managed
identity, or Azure CLI.

## Usage

```hcl
provider "azurerm" {
  features {}
}

provider "azuredevops" {}

data "azurerm_subnet" "agents" {
  name                 = var.vmss_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

data "azuredevops_project" "pool" {
  name = var.azuredevops_project_name
}

data "azuredevops_serviceendpoint_azurerm" "pool" {
  project_id            = data.azuredevops_project.pool.id
  service_endpoint_name = var.azuredevops_service_endpoint_name
}

module "terraform-azurerm-vmss-devops-agent" {
  source = "tonyskidmore/vmss-devops-agent/azurerm"

  elastic_pool_name                   = var.elastic_pool_name
  elastic_pool_project_id             = data.azuredevops_project.pool.id
  elastic_pool_service_endpoint_id    = data.azuredevops_serviceendpoint_azurerm.pool.id
  elastic_pool_service_endpoint_scope = data.azuredevops_project.pool.id
  vmss_admin_password                 = var.vmss_admin_password
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = var.vmss_resource_group_name
  vmss_subnet_id                      = data.azurerm_subnet.agents.id
  vmss_custom_data_script             = var.vmss_custom_data_script
  tags                                = var.tags
}
```

## Elastic Pool Inputs

Required:

- `elastic_pool_service_endpoint_id`
- `elastic_pool_service_endpoint_scope`
- `vmss_resource_group_name`
- `vmss_subnet_id`

Optional:

- `elastic_pool_name`
- `elastic_pool_project_id`
- `elastic_pool_desired_idle`
- `elastic_pool_max_capacity`
- `elastic_pool_recycle_after_each_use`
- `elastic_pool_time_to_live_minutes`
- `elastic_pool_agent_interactive_ui`
- `elastic_pool_auto_provision`
- `elastic_pool_auto_update`

## Outputs

- `elastic_pool_id`
- `elastic_pool`
- `vmss_id`
- `vmss_system_assigned_identity_id`
- `vmss_user_assigned_identity_ids`

## Notes

- The examples in this repo now use provider-native Azure DevOps data sources
  to resolve the project and AzureRM service connection by name.
- The VMSS module continues to enforce Azure DevOps-compatible scale set
  settings such as manual upgrade mode and disabled overprovisioning.
- Destroy operations can still fail while jobs are running against the pool.
