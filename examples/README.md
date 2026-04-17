# Examples

Examples `001` through `006` in this repo now use the provider-native
`azuredevops` workflow:

- authenticate Azure DevOps through the provider
- resolve the Azure DevOps project with `data.azuredevops_project`
- resolve the AzureRM service connection with `data.azuredevops_serviceendpoint_azurerm`
- pass IDs into the module's `elastic_pool_*` inputs

Each example can be initialized locally with:

```bash
terraform init -backend=false
terraform plan
```
