# Azure DevOps Demo Environment

This creates an Azure DevOps project that can be used to run Pipelines to create other examples.
By default the project will be called `demo-vmss`.  It will create the following items in the project:

| Item                       | Description                                                                                          |
|----------------------------|------------------------------------------------------------------------------------------------------|
| AzureRM Service Connection | Service connection that will be used as the connection for Azure Scale Set agents                    |
| Repos                      | Azure Repos created to import this module and an associated Azure Pipelines repository from GitHub   |
| Pipelines                  | Pipelines will be created and given the necessary permissions to the required Azure DevOps resources |
| Environment                | A Pipelines environment will be created and is referenced by the YAML Pipelines                      |
| Variable group             | A variable group is created to store the variables and secrets required for Pipeline execution       |

_Note:_
The demo environment uses Azure Repos but that is only to make things easier for creating the demos, it is not a prerequisite to using the module.
The Azure DevOps YAML pipelines using in the demo environment are located in a separate repo: [azure-pipelines-yaml](https://github.com/tonyskidmore/azure-pipelines-yaml).

Azure resources are also create:

| Item                   | Default                       | Description                                                                                          |
|------------------------|-------------------------------|------------------------------------------------------------------------------------------------------|
| Resource group         | rg-demo-azure-devops-vmss     | Service connection that will be used as the connection for Azure Scale Set agents                    |
| Network security group | nsg-demo-azure-devops-vmss    | A default Network security                                                                           |
| Storage account        | sademovmss{000000}            | Storage account for Terraform state named sademovmss + 6 numeric digits                              |
| Virtual network        | vnet-demo-azure-devops-vmss   | Virtual network with an address space of 192.168.0.0/16                                              |
| Subnet                 | snet-demo-azure-devops-vmss   | Subnet with a subnet mask of 192.168.0.0/24                                                          |

_Note:_
All resources are deployed into the single resource group to keep things contained and easier to destroy.
Individual examples will create additional resources in the same resource group.
The demos makes efforts to keep costs as low as possible but some charges will be incurred for the resources deployed.

## Requirements

The requirements defined in the main README of this repository plus the below:

### Azure
Subscription level service principal with:
Contributor + User Access Administrator
OR
Owner

### Azure DevOps
Personal Access Token - Full Access


## Environment variables

Certain environment variables need to be defined prior to creating the demo environment.


````bash

# authenticate Terraform to Azure - replace values with your tenant, subscription and service principal values
# set the values containing secrets and values
 export ARM_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
 export ARM_TENANT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_ID=00000000-0000-0000-0000-000000000000
 export ARM_CLIENT_SECRET=<secret-here>

 export AZDO_PERSONAL_ACCESS_TOKEN="your PAT here" # full access
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/tonyskidmore" # your organization

# reference the above to pass into Terraform
export TF_VAR_ado_org="$AZDO_ORG_SERVICE_URL"
export TF_VAR_ado_ext_pat="$AZDO_PERSONAL_ACCESS_TOKEN"
export TF_VAR_serviceprincipalid="$ARM_CLIENT_ID"
export TF_VAR_serviceprincipalkey="$ARM_CLIENT_SECRET"
export TF_VAR_azurerm_spn_tenantid="$ARM_TENANT_ID"
export TF_VAR_azurerm_subscription_id="$ARM_SUBSCRIPTION_ID"

git clone https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent.git
cd demo_environment
terraform init
terraform plan -out tfplan # -var ado_project_visibility=public # add this to make public for unlimited parallel pipelines
terraform apply tfplan

````
_Note:_
The Azure DevOps Terraform provider occasionally throws up `Internal Error Occurred` errors.
If it does just re-run the `plan` and `apply` steps and it should go through OK.



Open Azure DevOps and explore the `demo-vmss` project.  Review the [examples README](../examples/README.md) to see what examples are available.

To destroy the demo environment, first run the destroy pipeline for each of any examples you have deployed and then run:

````bash

terraform plan -destroy -out tfplan
terraform apply tfplan

````

If you find yourself in a position that things have not destroyed correctly you can take manual steps to tidy up:

* In Azure DevOps delete the `demo-vmss` project
* In Azure DevOps at the Organization level remove teh `vmss-bootstrap-pool` and any `vmss-agent-pool-*` agent pools that were created by the demo environment
* In Azure delete the `rg-demo-azure-devops-vmss` resource group
* Locally from the `demo_environment` directory remove `terraform.tfstate*`
