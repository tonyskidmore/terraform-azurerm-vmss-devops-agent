# Azure Virtual Machine Scale Set

In this example we are creating a pool named `vmss-agent-pool-linux-004` based on an Azure MarketPlace Ubuntu 20.04 image.

This example adds a VMSS data disk (minimal 10GB by default) as the location to store Docker data.  The cloud-init configuration (cloud-init.tpl) configures this additional storage and configures Docker to use the data disk as the `data-root`.  This might be useful if you use a lot of or large container images and you want to separate them onto their own disk and not use the default OS disk.

Deploy the agent pool by running the pipeline `004-docker-data-disk-terraform` created by the `demo_environment`.  Then use the `004-docker-data-disk-test` and `004-docker-data-disk-host-test` pipelines to check the deployment.

The `demo_environment` pipelines are documented below.

| Pipeline                        | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| 004-docker-data-disk-terraform  | create/destroy the `vmss-agent-pool-linux-004` agent pool/VMSS                           |
| 004-docker-data-disk-test       | runs test container jobs on the the above agent pool/VMSS                                |
| 004-docker-data-disk-host-test  | runs test jobs on the host to check storage location (also demonstrates example cleanup) |

The `004-docker-data-disk-test` includes an example of running Terraform in a container, authenticated to Azure.
This uses the Azure Resource Manager service connection created in the demo environment.

_Note_:
If using the `demo_environment` pipeline it will deploy 2 instances to begin with, which means that cost will be incurred from the time the Scale Set agent is deployed.  To keep costs down ensure that after running and testing that you run `004-docker-data-disk-terraform` pipeline and choose the `terraform-destroy` parameter option.


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
| tags | Map of the tags to use for the resources that are deployed | `map(string)` | `{}` | no |
| vmss\_admin\_password | Password to allocate to the admin user account | `string` | n/a | yes |
| vmss\_data\_disks | Additional data disks | <pre>list(object({<br>    caching              = string<br>    create_option        = string<br>    disk_size_gb         = string<br>    lun                  = number<br>    storage_account_type = string<br>  }))</pre> | `[]` | no |
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
  vmss_data_disks          = var.vmss_data_disks
  vmss_custom_data_data    = local.vmss_custom_data_data
  tags                     = var.tags
}
```
<!-- END_TF_DOCS -->
