# 003-multi_zone

Multi-zone example for the provider-native
`terraform-azurerm-vmss-devops-agent` module.

This example uses:

- `elastic_pool_desired_idle`
- `elastic_pool_max_capacity`
- `elastic_pool_time_to_live_minutes`
- `vmss_zones`

The scale helper files in `scale/` now use the same provider-native elastic
pool variable names.

Run:

```bash
terraform init -backend=false
terraform plan
```
