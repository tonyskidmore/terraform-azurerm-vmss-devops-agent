# Example - Create Azure DevOps Scale Set with custom custom_data

In this example we are creating a pool named `vmss-mkt-image-002` based on an Azure MarketPlace Ubuntu 20.04 image.

We are setting `ado_pool_desired_idle` to 1 to indicate that we want a single agent deployed into the pool, going up to a maximum of 2 active instances.  `vmss_custom_data_data` is defined with the base64 encoded content of the local `cloud-init.tpl` template file, which is passed to [cloud-init](https://cloud-init.io/).  Setting `ado_pool_ttl_mins` to 15 will discard instances after 15 minutes of not being used.  A system assigned managed identity will be used to upload a file to a storage container blob by the cloud-init script.  The file upload is just an example of supplying custom data that can easily be validated by checking that the blob has been created as expected after the VMSS initial instance has been created.

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.
