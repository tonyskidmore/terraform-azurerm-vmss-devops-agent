# Azure Kubernetes Service Agent Pool

In this example we are creating an AKS hosted pool named `k8s-agents-pool-001`.

The `demo_environment` pipelines are documented below.

| Pipeline                        | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| 007-aks-terraform               | create/destroy the AKS cluster `test-cluster` in `rg-demo-azure-devops-aks`              |
| 007-aks-agents-terraform        | creates the `k8s-agents-pool-001` agent pool                                             |
| 007-aks-agents-test             | runs a matrix of container jobs that runs init/plan using multiple versions of terraform |

_Note_:
If using the `demo_environment` pipeline it will deploy an AKS instance to begin with, which means that cost will be incurred from the time it is deployed.
To keep costs down ensure that after running and testing that you run `007-aks-agents-terraform` and then the `007-aks-terraform` pipeline and choose the `terraform-destroy` parameter option.


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
  source                          = "Azure/aks/azurerm"
  version                         = "6.8.0"
  prefix                          = "prefix-${random_id.prefix.hex}"
  resource_group_name             = var.resource_group_name
  cluster_name                    = var.cluster_name
  node_resource_group             = var.node_resource_group
  vnet_subnet_id                  = data.azurerm_subnet.agents.id
  rbac_aad                        = var.rbac_aad
  log_analytics_workspace_enabled = var.log_analytics_workspace_enabled
  private_cluster_enabled         = var.private_cluster_enabled
}
```
<!-- END_TF_DOCS -->
