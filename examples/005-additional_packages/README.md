# 005-additional_packages

Additional-packages example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example looks up the Azure DevOps project and AzureRM service connection
by name and passes provider-native elastic pool settings into the module.

Run:

```bash
terraform init -backend=false
terraform plan
```
