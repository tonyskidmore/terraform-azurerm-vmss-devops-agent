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
| terraform | >= 1.3 |
| azurerm | >= 3.47.0, < 4.0 |
| random | >=3.4.0 |
| tls | >= 3.1 |
## Providers

| Name | Version |
|------|---------|
| azurerm | 3.51.0 |
| random | 3.4.3 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| terraform-azurerm-aks-devops-agent | tonyskidmore/aks-devops-agent/azurerm | 0.0.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_subnet\_name | Name of subnet where the vmss will be connected | `string` | n/a | yes |
| node\_resource\_group | Resource group name for the AKS cluster | `string` | n/a | yes |
| vmss\_resource\_group\_name | Existing resource group name of where the VMSS will be created | `string` | n/a | yes |
| vmss\_vnet\_name | Name of the Vnet that the target subnet is a member of | `string` | n/a | yes |
## Outputs

No outputs.

Example

```hcl

provider "azurerm" {
  features {}
}

resource "random_id" "prefix" {
  byte_length = 8
}

data "azurerm_subnet" "agents" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.vmss_resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

module "terraform-azurerm-aks-devops-agent" {
  source              = "tonyskidmore/aks-devops-agent/azurerm"
  version             = "0.0.2"
  prefix              = "prefix-${random_id.prefix.hex}"
  resource_group_name = data.azurerm_resource_group.demo.name

  node_resource_group            = var.node_resource_group
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  # https://learn.microsoft.com/en-us/azure/aks/egress-outboundtype
  # https://learn.microsoft.com/en-us/azure/aks/nat-gateway
  net_profile_outbound_type = "managedNATGateway"
  net_profile_service_cidr  = "10.0.0.0/16"
  network_plugin            = "azure"
  network_policy            = "azure"
  vnet_subnet_id            = data.azurerm_subnet.agents.id
}

data "azurerm_resource_group" "demo" {
  name = var.vmss_resource_group_name
}
```
<!-- END_TF_DOCS -->
