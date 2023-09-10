# Azure Kubernetes Service Agent Pool

In this example we are creating an AKS hosted pool named `k8s-agents-pool-001`.
Although this example does not create a VMSS agent pool, it does use the `vmss-bootstrap-pool` to
perform the deployment of an AKS cluster and self-hosted agents deployed to the cluster.

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

data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

module "terraform-kubernetes-azure-devops-agent" {
  source      = "tonyskidmore/azure-devops-agent/kubernetes"
  version     = "0.0.4"
  ado_ext_pat = var.ado_ext_pat
  ado_org     = var.ado_org
}
```
<!-- END_TF_DOCS -->
