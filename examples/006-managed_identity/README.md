# 006-managed_identity

Managed-identity VMSS example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example:

- uses provider-native Azure DevOps data sources for project and service connection lookup
- creates a system-assigned identity on the VMSS
- keeps the Azure DevOps elastic pool configuration provider-native

Run:

```bash
terraform init -backend=false
terraform plan
```
