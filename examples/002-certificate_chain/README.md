# 002-certificate_chain

Certificate-chain example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example resolves the Azure DevOps project and AzureRM service connection
with `azuredevops` data sources and enables
`elastic_pool_recycle_after_each_use = true`.

Configure:

- `azuredevops_project_name`
- `azuredevops_service_endpoint_name`
- VMSS image inputs in `terraform.tfvars`

Then run:

```bash
terraform init -backend=false
terraform plan
```
