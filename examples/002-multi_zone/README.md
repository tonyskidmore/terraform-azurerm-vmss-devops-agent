# Example - Create Multi-Zone Azure DevOps Scale Set

In this example we are creating a pool named `vmss-mkt-image-004` based on an Azure MarketPlace Ubuntu 20.04 image.

We are setting `ado_pool_desired_idle` to 3 to indicate that we want 3 standby agents deployed into the pool, going up to a maximum of 5 active instances.  The `vmss_zones` is defined so that each instance in the VMSS is spread across availability zones.

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| azurerm | >=3.1.0 |
## Providers

| Name | Version |
|------|---------|
| azurerm | 3.31.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| terraform-azurerm-vmss-devops-agent | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ado\_ext\_pat | Azure DevOps personal access token | `string` | n/a | yes |
## Outputs

No outputs.

Example

```hcl
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg-vmss-azdo-agents-01"
}


module "terraform-azurerm-vmss-devops-agent" {
  source = "../../"
  # this will be supplied by exporting TF_VAR_ado_ext_pat before running terraform
  # this an Azure DevOps Personal Access Token to create and manage the agent pool
  ado_ext_pat            = var.ado_ext_pat
  ado_org                = "https://dev.azure.com/tonyskidmore"
  ado_project            = "ve-vmss"
  ado_service_connection = "ve-vmss"
  ado_pool_name          = "vmss-mkt-image-004"
  # use the ado_pool_desired_idle variable to control VMSS instances, not the vmss_instances variable
  ado_pool_desired_idle         = 3
  ado_pool_max_capacity         = 5
  ado_pool_ttl_mins             = 15
  vmss_name                     = "vmss-mkt-image-004"
  vmss_ssh_public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeww5Jfj/kYfBEqdsQtfRUGtnCjdbiIpL4N0XD46IMJuzUKjDI3NJIMCRw59r90cZxuY5poks5/24FcLZUtguZTkT0gupx6lp8F16zadAgEPmV9J9N6xhGyzK4dOjEiJuTu3f4jrFvs4pyphPT/gni4DBMOMOQb8v2ili20qJ8ew964d88fplrwwtKFdR5RI4AXNvDc8iWsbmbej1azXERcu485Hj3ThPNyXu2tfi7PvzYmVZlhlYKCtvh0DWW/BKPXuM8wT/ASM0e7maKSTvL1uhTUuhAicDRkwLFKP5o0vm6s3ERgWCOmhWMklS/pbCWLfjXcgs8rb7F5iiy9xcCT1Ud9SL+rZdQAOhT6Shx0OXQUJRLiMtEh6KD3YC95EHJQ8tYn3dspM1SsO6n4XmnzXT2fjvfpPF4DKdXA9tVmbfK2UscdumMqaFwka7KAiwMtHBgQkCGOPTjGfDTrJn9RovG1ifvzWlCGHwFLl1JmbaE8Cz6Rw4Gm1I7X3aRIHk= vmss test"
  vmss_resource_group_name      = "rg-vmss-azdo-agents-01"
  vmss_subnet_name              = "snet-azdo-agents-01"
  vmss_vnet_resource_group_name = "rg-azdo-agents-networks-01"
  vmss_vnet_name                = "vnet-azdo-agents-01"
  # split the nodes over 3 availability zones
  vmss_zones = ["1", "2", "3"]
}
```
<!-- END_TF_DOCS -->