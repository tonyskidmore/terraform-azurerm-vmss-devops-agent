# Example - Create Azure DevOps Scale Set with custom custom_data adding custom certificate chain

In this example we are creating a pool named `vmss-agent-pool-linux-002` based on an Azure MarketPlace Ubuntu 20.04 image.

It demonstrates how to add a custom certificate chain to VMSS instances.  This might be required if TLS inspection occurs at the network level.

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
| terraform-azurerm-vmss-devops-agent | tonyskidmore/vmss-devops-agent/azurerm | 0.2.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ado\_ext\_pat | Azure DevOps Personal Access Token | `string` | n/a | yes |
| ado\_org | Azure DevOps organization | `string` | n/a | yes |
| ado\_pool\_name | Azure DevOps agent pool name | `string` | n/a | yes |
| ado\_project | Azure DevOps organization | `string` | n/a | yes |
| ado\_service\_connection | Azure DevOps organiservice connection name | `string` | n/a | yes |
| tags | Map of the tags to use for the resources that are deployed | `map(string)` | `{}` | no |
| vmss\_name | Name of the Virtual Machine Scale Set to create | `string` | n/a | yes |
| vmss\_resource\_group\_name | Existing resource group name of where the VMSS will be created | `string` | n/a | yes |
| vmss\_source\_image\_offer | Azure Virtual Machine Scale Set Source Image Offer | `string` | n/a | yes |
| vmss\_source\_image\_sku | Azure Virtual Machine Scale Set Source Image SKU | `string` | n/a | yes |
| vmss\_subnet\_name | Name of subnet where the vmss will be connected | `string` | n/a | yes |
| vmss\_vnet\_name | Name of the Vnet that the target subnet is a member of | `string` | n/a | yes |
## Outputs

No outputs.

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

resource "tls_private_key" "vmss_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "terraform-azurerm-vmss-devops-agent" {
  source                     = "tonyskidmore/vmss-devops-agent/azurerm"
  version                    = "0.2.2"
  ado_org                    = var.ado_org
  ado_pool_name              = var.ado_pool_name
  ado_project                = var.ado_project
  ado_pool_recycle_after_use = true
  ado_service_connection     = var.ado_service_connection
  vmss_ssh_public_key        = tls_private_key.vmss_ssh.public_key_openssh
  vmss_name                  = var.vmss_name
  vmss_resource_group_name   = var.vmss_resource_group_name
  vmss_subnet_id             = data.azurerm_subnet.agents.id
  tags                       = var.tags
  vmss_custom_data_data      = local.vmss_custom_data_data
  vmss_source_image_offer    = var.vmss_source_image_offer
  vmss_source_image_sku      = var.vmss_source_image_sku
}
```
<!-- END_TF_DOCS -->
