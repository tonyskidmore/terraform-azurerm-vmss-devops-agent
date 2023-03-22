
# terraform-azurerm-vmss-devops-agent

[![GitHub Super-Linter](https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

Terraform Azure DevOps virtual machine scale set agent module

A getting started, simple standalone example of using the module can be found in the [ado-vmss-simple-demo](https://github.com/tonyskidmore/ado-vmss-simple-demo) repository.


## Overview

This Terraform module will create an Azure Virtual Machine Scale Set in Azure and an associated Azure virtual machine scale set agent pool in Azure DevOps.

It is an abstraction over two child modules:

* [Terraform azurerm Virtual Machine Scale Set module](https://registry.terraform.io/modules/tonyskidmore/vmss/azurerm/latest)
* [Terraform Azure DevOps Scale Set Agent module](https://registry.terraform.io/modules/tonyskidmore/azure-devops-elasticpool/shell/latest)

The child modules can be used separately if required.

This brings the functionality together in an all in one module with a number of examples that demonstrate how the module and VMSS can be used within Azure DevOps for self-hosted agents.
The default behaviour is that the VMSS instances will be configured as Docker hosts, but that can be disabled if desired by setting the
`vmss_custom_data_script` variable to `null`.  Alternatively, supplying a base64 encoded value for `vmss_custom_data_data`, which overrides the `vmss_custom_data_script` variable.

Once the Azure DevOps Terraform provider has been updated to use an updated [SDK][blocking-issue] we can use that to replace the workaround of using the [Terraform Azure DevOps Scale Set Agent module](https://registry.terraform.io/modules/tonyskidmore/azure-devops-elasticpool/shell/latest).

## Requirements

Currently, due to the fact that creating an [Agent Pool - Azure virtual machine scale set][scale-agents] is currently [blocked][blocking-issue]
because the SDK used by the [Azure DevOps Terraform Provider][terraform-provider-azuredevops]
does not support the required functionality, this module uses the [Terraform shell provider][shell-provider] as a workaround.  Therefore, it inherits most of the requirements of the [Terraform Azure DevOps Scale Set Agent module](https://registry.terraform.io/modules/tonyskidmore/azure-devops-elasticpool/shell/latest) module, namely:

* An Azure subscription.
  _Note:_ you can get started with a [Azure free account][azure-free]

* An [Azure DevOps][azdo] [Organization][azdo-org].
  _Note:_ you can sign up for free in the preceding link.

* An [Azure][azdo-connect-azure] service connection to the subscription where your Azure Virtual Machine Scale Set is located.

* An [Azure DevOps][azdo-project] project.

* An Azure DevOps [Personal Access Token][azdo-pat](PAT) created with at least Agent Pools (Read & manage) and Service Connections (Read & query) permissions (some examples will need more extensive permissions)

* A Linux based system is required to execute this Terraform module, with the following commands installed:
  - cat
  - curl
  - sed
  - jq

The Azure DevOps PAT and other required variables need be passed to the Terraform configuration by any standard mechanism, for example:

````bash

 export AZURE_DEVOPS_EXT_PAT="ckusfcc8ope2soot1yuovmdvlgtfgj9nio2orfwyvv5jsgcnwwga"
export TF_VAR_ado_ext_pat="$AZURE_DEVOPS_EXT_PAT"

````

_Note:_ The PAT is used for the initial creation of the agent pool and for subsequent Terraform operations.  Therefore, it would be advisable to create/use a service account for this rather than a standard user account.

A full example of passing the necessary variables can be seen in the [demo_environment/README.md](https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent/blob/main/demo_environment/README.md).


<!-- BEGIN_TF_DOCS -->



## Basic example

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
  version                  = "0.2.2"
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
## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ado_dirty"></a> [ado\_dirty](#input\_ado\_dirty) | Azure DevOps pool settings are dirty | `bool` | `false` | no |
| <a name="input_ado_org"></a> [ado\_org](#input\_ado\_org) | Azure DevOps Organization name | `string` | n/a | yes |
| <a name="input_ado_pool_auth_all_pipelines"></a> [ado\_pool\_auth\_all\_pipelines](#input\_ado\_pool\_auth\_all\_pipelines) | Setting to determine if all pipelines are authorized to use this TaskAgentPool by default (at create only) | `string` | `"True"` | no |
| <a name="input_ado_pool_auto_provision_projects"></a> [ado\_pool\_auto\_provision\_projects](#input\_ado\_pool\_auto\_provision\_projects) | Setting to automatically provision TaskAgentQueues in every project for the new pool (at create only) | `string` | `"True"` | no |
| <a name="input_ado_pool_desired_idle"></a> [ado\_pool\_desired\_idle](#input\_ado\_pool\_desired\_idle) | Number of machines to have ready waiting for jobs | `number` | `0` | no |
| <a name="input_ado_pool_desired_size"></a> [ado\_pool\_desired\_size](#input\_ado\_pool\_desired\_size) | The desired size of the pool | `number` | `0` | no |
| <a name="input_ado_pool_max_capacity"></a> [ado\_pool\_max\_capacity](#input\_ado\_pool\_max\_capacity) | Maximum number of machines that will exist in the elastic pool | `number` | `2` | no |
| <a name="input_ado_pool_max_saved_node_count"></a> [ado\_pool\_max\_saved\_node\_count](#input\_ado\_pool\_max\_saved\_node\_count) | Keep machines in the pool on failure for investigation | `number` | `0` | no |
| <a name="input_ado_pool_name"></a> [ado\_pool\_name](#input\_ado\_pool\_name) | Azure DevOps agent pool name | `string` | `"azdo-vmss-pool-001"` | no |
| <a name="input_ado_pool_os_type"></a> [ado\_pool\_os\_type](#input\_ado\_pool\_os\_type) | Operating system type of the nodes in the pool | `string` | `"linux"` | no |
| <a name="input_ado_pool_recycle_after_use"></a> [ado\_pool\_recycle\_after\_use](#input\_ado\_pool\_recycle\_after\_use) | Discard machines after each job completes | `bool` | `false` | no |
| <a name="input_ado_pool_sizing_attempts"></a> [ado\_pool\_sizing\_attempts](#input\_ado\_pool\_sizing\_attempts) | The number of sizing attempts executed while trying to achieve a desired size | `number` | `0` | no |
| <a name="input_ado_pool_ttl_mins"></a> [ado\_pool\_ttl\_mins](#input\_ado\_pool\_ttl\_mins) | The minimum time in minutes to keep idle agents alive | `number` | `15` | no |
| <a name="input_ado_project"></a> [ado\_project](#input\_ado\_project) | Azure DevOps project name where service connection exists and optionally where pool will only be created | `string` | n/a | yes |
| <a name="input_ado_project_only"></a> [ado\_project\_only](#input\_ado\_project\_only) | Only create the agent pool in the Azure DevOps pool specified? (at create only) | `string` | `"False"` | no |
| <a name="input_ado_service_connection"></a> [ado\_service\_connection](#input\_ado\_service\_connection) | Azure DevOps azure service connection name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to Azure Virtual Machine Scale | `map(string)` | `{}` | no |
| <a name="input_vmss_admin_password"></a> [vmss\_admin\_password](#input\_vmss\_admin\_password) | Azure Virtual Machine Scale Set instance administrator password | `string` | `null` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | Azure Virtual Machine Scale Set instance administrator name | `string` | `"adminuser"` | no |
| <a name="input_vmss_custom_data_data"></a> [vmss\_custom\_data\_data](#input\_vmss\_custom\_data\_data) | The base64 encoded data to use as custom data for the VMSS instances | `string` | `null` | no |
| <a name="input_vmss_custom_data_script"></a> [vmss\_custom\_data\_script](#input\_vmss\_custom\_data\_script) | The path to the script that will be base64 encoded custom data for the VMSS instances | `string` | `"scripts/cloud-init/cloud-init"` | no |
| <a name="input_vmss_data_disks"></a> [vmss\_data\_disks](#input\_vmss\_data\_disks) | Additional data disks | <pre>list(object({<br>    caching              = string<br>    create_option        = string<br>    disk_size_gb         = string<br>    lun                  = number<br>    storage_account_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_vmss_disk_size_gb"></a> [vmss\_disk\_size\_gb](#input\_vmss\_disk\_size\_gb) | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine Scale Set is sourced from | `number` | `null` | no |
| <a name="input_vmss_encryption_at_host_enabled"></a> [vmss\_encryption\_at\_host\_enabled](#input\_vmss\_encryption\_at\_host\_enabled) | Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? | `bool` | `false` | no |
| <a name="input_vmss_identity_ids"></a> [vmss\_identity\_ids](#input\_vmss\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine Scale Set | `list(string)` | `null` | no |
| <a name="input_vmss_identity_type"></a> [vmss\_identity\_type](#input\_vmss\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine Scale Set | `string` | `null` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | Azure Virtual Machine Scale Set number of instances | `number` | `0` | no |
| <a name="input_vmss_load_balancer_backend_address_pool_ids"></a> [vmss\_load\_balancer\_backend\_address\_pool\_ids](#input\_vmss\_load\_balancer\_backend\_address\_pool\_ids) | A list of Backend Address Pools IDs from a Load Balancer which this Virtual Machine Scale Set should be connected to | `list(string)` | `null` | no |
| <a name="input_vmss_location"></a> [vmss\_location](#input\_vmss\_location) | Existing resource group name of where the VMSS will be created | `string` | `"uksouth"` | no |
| <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name) | Azure Virtual Machine Scale Set name | `string` | `"azdo-vmss-pool-001"` | no |
| <a name="input_vmss_os"></a> [vmss\_os](#input\_vmss\_os) | Whether to process the Linux Virtual Machine Scale Set resource | `string` | `"linux"` | no |
| <a name="input_vmss_os_disk_caching"></a> [vmss\_os\_disk\_caching](#input\_vmss\_os\_disk\_caching) | The Type of Caching which should be used for the Internal OS Disk | `string` | `"ReadOnly"` | no |
| <a name="input_vmss_os_disk_storage_account_type"></a> [vmss\_os\_disk\_storage\_account\_type](#input\_vmss\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_vmss_resource_group_name"></a> [vmss\_resource\_group\_name](#input\_vmss\_resource\_group\_name) | Existing resource group name of where the VMSS will be created | `string` | n/a | yes |
| <a name="input_vmss_resource_prefix"></a> [vmss\_resource\_prefix](#input\_vmss\_resource\_prefix) | Prefix to apply to VMSS resources | `string` | `"vmss"` | no |
| <a name="input_vmss_se_enabled"></a> [vmss\_se\_enabled](#input\_vmss\_se\_enabled) | Whether to process the Linux Virtual Machine Scale Set extension resource | `bool` | `false` | no |
| <a name="input_vmss_se_settings_data"></a> [vmss\_se\_settings\_data](#input\_vmss\_se\_settings\_data) | The base64 encoded data to use as the script for the VMSS custom script extension | `string` | `null` | no |
| <a name="input_vmss_se_settings_script"></a> [vmss\_se\_settings\_script](#input\_vmss\_se\_settings\_script) | The path of the file to use as the script for the VMSS custom script extension | `string` | `"scripts/vmss-startup.sh"` | no |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | Azure Virtual Machine Scale Set SKU | `string` | `"Standard_B2s"` | no |
| <a name="input_vmss_source_image_id"></a> [vmss\_source\_image\_id](#input\_vmss\_source\_image\_id) | Azure Virtual Machine Scale Set Image ID | `string` | `null` | no |
| <a name="input_vmss_source_image_offer"></a> [vmss\_source\_image\_offer](#input\_vmss\_source\_image\_offer) | Azure Virtual Machine Scale Set Source Image Offer | `string` | `"0001-com-ubuntu-server-focal"` | no |
| <a name="input_vmss_source_image_publisher"></a> [vmss\_source\_image\_publisher](#input\_vmss\_source\_image\_publisher) | Azure Virtual Machine Scale Set Source Image Publisher | `string` | `"Canonical"` | no |
| <a name="input_vmss_source_image_sku"></a> [vmss\_source\_image\_sku](#input\_vmss\_source\_image\_sku) | Azure Virtual Machine Scale Set Source Image SKU | `string` | `"20_04-lts"` | no |
| <a name="input_vmss_source_image_version"></a> [vmss\_source\_image\_version](#input\_vmss\_source\_image\_version) | Azure Virtual Machine Scale Set Source Image Version | `string` | `"latest"` | no |
| <a name="input_vmss_ssh_public_key"></a> [vmss\_ssh\_public\_key](#input\_vmss\_ssh\_public\_key) | Public key to use for SSH access to VMs | `string` | `""` | no |
| <a name="input_vmss_storage_account_uri"></a> [vmss\_storage\_account\_uri](#input\_vmss\_storage\_account\_uri) | VMSS boot diagnostics storage account URI | `string` | `null` | no |
| <a name="input_vmss_subnet_id"></a> [vmss\_subnet\_id](#input\_vmss\_subnet\_id) | Existing subnet ID of where the VMSS will be connected | `string` | n/a | yes |
| <a name="input_vmss_zones"></a> [vmss\_zones](#input\_vmss\_zones) | A collection of availability zones to spread the Virtual Machines over | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ado_vmss_pool_output"></a> [ado\_vmss\_pool\_output](#output\_ado\_vmss\_pool\_output) | Azure DevOps VMSS Agent Pool output |
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | Virtual Machine Scale Set ID |
| <a name="output_vmss_system_assigned_identity_id"></a> [vmss\_system\_assigned\_identity\_id](#output\_vmss\_system\_assigned\_identity\_id) | Virtual Machine Scale Set SystemAssigned Identity |
| <a name="output_vmss_user_assigned_identity_ids"></a> [vmss\_user\_assigned\_identity\_ids](#output\_vmss\_user\_assigned\_identity\_ids) | Virtual Machine Scale Set UserAssigned Identities |

## Providers

No providers.


<!-- END_TF_DOCS -->

## Known issues

* Running a `terrform destroy` while pipelines are running will result in an error.  If pipelines are expected to be running then it is best to disable agents and then run the destroy.
  Although, re-running the destroy should subsequently work after an error when pipelines are not running.

[scale-agents]: https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents
[shell-provider]: https://registry.terraform.io/providers/scottwinkler/shell/1.7.10
[blocking-issue]: https://github.com/microsoft/terraform-provider-azuredevops/issues/204
[terraform-provider-azuredevops]: https://github.com/microsoft/terraform-provider-azuredevops
[azdo-pat]: https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate
[azure-free]: https://azure.microsoft.com/en-gb/free
[azdo]: https://azure.microsoft.com/en-gb/products/devops
[azdo-org]: https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization
[azdo-project]: https://learn.microsoft.com/en-us/azure/devops/organizations/projects/create-project
[azdo-connect-azure]: https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure
