# 001-admin_password

Admin-password example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example:

- looks up an existing Azure DevOps project by `azuredevops_project_name`
- looks up an existing AzureRM service connection by `azuredevops_service_endpoint_name`
- creates a VMSS-backed Azure DevOps agent pool

Set Azure DevOps provider authentication with environment variables such as
`AZDO_ORG_SERVICE_URL` and `AZDO_PERSONAL_ACCESS_TOKEN`, then run:

```bash
terraform init -backend=false
terraform plan
```
