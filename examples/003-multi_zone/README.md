# Example - Create Multi-Zone Azure DevOps Scale Set

In this example we are creating a pool named `vmss-mkt-image-004` based on an Azure MarketPlace Ubuntu 20.04 image.

We are setting `ado_pool_desired_idle` to 3 to indicate that we want 3 standby agents deployed into the pool, going up to a maximum of 5 active instances.  The `vmss_zones` is defined so that each instance in the VMSS is spread across availability zones.

````bash

cd demo_environment
terraform plan -var ado_project_visibility=public -out tfplan

````

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >=3.1.0 |
| shell | ~>1.7.10 |
| tls | ~>4.0 |
## Providers

| Name | Version |
|------|---------|
| azurerm | 3.35.0 |
| tls | 4.0.4 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| terraform-azurerm-vmss-devops-agent | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ado\_ext\_pat | Azure DevOps Personal Access Token | `string` | n/a | yes |
| ado\_org | Azure DevOps organization | `string` | n/a | yes |
| ado\_pool\_desired\_idle | Number of machines to have ready waiting for jobs | `number` | n/a | yes |
| ado\_pool\_max\_capacity | Maximum number of machines that will exist in the elastic pool | `number` | n/a | yes |
| ado\_pool\_name | Azure DevOps agent pool name | `string` | n/a | yes |
| ado\_pool\_ttl\_mins | The minimum time in minutes to keep idle agents alive | `number` | n/a | yes |
| ado\_project | Azure DevOps organization | `string` | n/a | yes |
| ado\_service\_connection | Azure DevOps organiservice connection name | `string` | n/a | yes |
| tags | Map of the tags to use for the resources that are deployed | `map(string)` | `{}` | no |
| vmss\_name | Name of the Virtual Machine Scale Set to create | `string` | n/a | yes |
| vmss\_resource\_group\_name | Existing resource group name of where the VMSS will be created | `string` | n/a | yes |
| vmss\_subnet\_name | Name of subnet where the vmss will be connected | `string` | n/a | yes |
| vmss\_vnet\_name | Name of the Vnet that the target subnet is a member of | `string` | n/a | yes |
| vmss\_zones | A collection of availability zones to spread the Virtual Machines over | `list(string)` | `[]` | no |
## Outputs

No outputs.

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

resource "tls_private_key" "vmss_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


module "terraform-azurerm-vmss-devops-agent" {
  # TODO: update module path
  # source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  # version                  = "0.1.0"
  source                   = "../../"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = var.ado_project
  ado_service_connection   = var.ado_service_connection
  ado_pool_desired_idle    = var.ado_pool_desired_idle
  ado_pool_max_capacity    = var.ado_pool_max_capacity
  ado_pool_ttl_mins        = var.ado_pool_ttl_mins
  vmss_ssh_public_key      = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                = var.vmss_name
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = data.azurerm_subnet.agents.id
  vmss_zones               = var.vmss_zones
  tags                     = var.tags
}
```
<!-- END_TF_DOCS -->
