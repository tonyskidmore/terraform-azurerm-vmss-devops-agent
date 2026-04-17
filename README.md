# terraform-azurerm-vmss-devops-agent

Terraform module that creates:

- an Azure Virtual Machine Scale Set (via the sibling
  [`tonyskidmore/vmss/azurerm`](https://registry.terraform.io/modules/tonyskidmore/vmss/azurerm)
  module)
- an Azure DevOps VM scale set agent pool backed by that VMSS
  (`azuredevops_elastic_pool`)

As of v1.0.0, this module manages `azuredevops_elastic_pool` directly via the
`microsoft/azuredevops` provider; earlier versions wrapped a shell-based
intermediate module.

## Requirements

- Terraform `>= 1.10.0`
- `hashicorp/azurerm ~> 4.0`
- `microsoft/azuredevops ~> 1.15`
- An existing Azure DevOps AzureRM service connection
- An Azure DevOps project that owns that service connection

Azure DevOps provider authentication is configured outside the module using
the provider's supported mechanisms such as PAT, service principal, OIDC,
managed identity, or Azure CLI.

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
  source  = "tonyskidmore/vmss-devops-agent/azurerm"
  version = "~> 1.0"

  elastic_pool_name                   = var.elastic_pool_name
  elastic_pool_project_id             = data.azuredevops_project.pool.id
  elastic_pool_service_endpoint_id    = data.azuredevops_serviceendpoint_azurerm.pool.id
  elastic_pool_service_endpoint_scope = data.azuredevops_project.pool.id
  vmss_admin_password                 = var.vmss_admin_password
  vmss_name                           = var.vmss_name
  vmss_resource_group_name            = var.vmss_resource_group_name
  vmss_subnet_id                      = data.azurerm_subnet.agents.id
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
- `vmss_name`
- `vmss_unique_id`
- `vmss_identity` — flat object with `principal_id`, `tenant_id`,
  `user_assigned_identity_ids`

## Migrating from 0.2.x / 0.3.x to 1.0.0

### Provider and Terraform constraints

```hcl
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm     = { source = "hashicorp/azurerm",     version = "~> 4.0" }
    azuredevops = { source = "microsoft/azuredevops", version = "~> 1.15" }
  }
}
```

### Identity inputs — two variables → one object

Before (0.2.x / 0.3.x):

```hcl
module "agent" {
  source             = "tonyskidmore/vmss-devops-agent/azurerm"
  vmss_identity_type = "UserAssigned"
  vmss_identity_ids  = [azurerm_user_assigned_identity.agents.id]
  # ...
}
```

After (1.0.0):

```hcl
module "agent" {
  source  = "tonyskidmore/vmss-devops-agent/azurerm"
  version = "~> 1.0"
  vmss_identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agents.id]
  }
  # ...
}
```

### Outputs — read identity attributes from `vmss_identity`

Before:

```hcl
principal_id = module.agent.vmss_system_assigned_identity_id
user_ids     = module.agent.vmss_user_assigned_identity_ids
```

After:

```hcl
principal_id = module.agent.vmss_identity.principal_id
user_ids     = module.agent.vmss_identity.user_assigned_identity_ids
```

### Data disks — `disk_size_gb` is now a number

Before:

```hcl
vmss_data_disks = [{
  caching              = "None"
  create_option        = "Empty"
  disk_size_gb         = "10"   # string
  lun                  = 1
  storage_account_type = "Standard_LRS"
}]
```

After:

```hcl
vmss_data_disks = [{
  caching              = "None"
  create_option        = "Empty"
  disk_size_gb         = 10     # number
  lun                  = 1
  storage_account_type = "Standard_LRS"
}]
```

### SSH key — `null` instead of `""`

The default for `vmss_ssh_public_key` is now `null`. Consumers that explicitly
passed `""` to opt out should pass `null` (or simply omit the input).

## Notes

- The examples in this repo use provider-native Azure DevOps data sources
  to resolve the project and AzureRM service connection by name.
- The VMSS module continues to enforce Azure DevOps-compatible scale set
  settings such as manual upgrade mode and disabled overprovisioning.
- Destroy operations can still fail while jobs are running against the pool.

## Development

- `scripts/test.sh` — runs `terraform fmt -check`, module-root `validate`,
  native `terraform test` with mocked providers, and iterates
  `scripts/test-examples.sh` across every example. Requires no Azure
  credentials.
- `scripts/test-examples.sh [--with-plan]` — `init -backend=false` +
  `validate` on each example. `--with-plan` additionally runs `terraform
  plan`; any example that reads Azure data sources will need real
  credentials for `plan`.
