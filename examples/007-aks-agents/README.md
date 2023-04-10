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

No requirements.
## Providers

No providers.
## Modules

No modules.
## Inputs

No inputs.
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
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vmss_vnet_name
}

module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "6.8.0"
  prefix              = "prefix-${random_id.prefix.hex}"
  resource_group_name = var.resource_group_name
  cluster_name        = var.cluster_name
  node_resource_group = var.node_resource_group
  vnet_subnet_id      = data.azurerm_subnet.agents.id
}
```
<!-- END_TF_DOCS -->
