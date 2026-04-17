# 004-docker_data_disk

Docker data disk example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example keeps the Azure DevOps integration provider-native and adds a data
disk to the VMSS while setting `elastic_pool_desired_idle`.

Run:

```bash
terraform init -backend=false
terraform plan
```
