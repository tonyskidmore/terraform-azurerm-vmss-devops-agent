# Example - Create Multi-Zone Azure DevOps Scale Set

In this example we are creating a pool named `vmss-mkt-image-004` based on an Azure MarketPlace Ubuntu 20.04 image.

We are setting `ado_pool_desired_idle` to 3 to indicate that we want 3 standby agents deployed into the pool, going up to a maximum of 5 active instances.  The `vmss_zones` is defined so that each instance in the VMSS is spread across availability zones.

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.
