# Example - Create Azure DevOps Scale Set using Azure Compute Gallery Image

In this example we are creating a pool named `vmss-acg-image-001` based on a [runner-images](https://github.com/actions/runner-images) image stored in an Azure Compute Gallery, as described in [Creating Ubuntu 20.04 Azure DevOps Microsoft Agent Image in Azure Compute Gallery Image](https://www.skidmore.co.uk/post/2022_04_19_azure_devops_vmss_agents_part1/).

We are setting `ado_pool_desired_idle` to 1 to indicate that we want at least a single idle agent, going up to a maximum of 2 active instances.  The setting `vmss_custom_data_script = ""` indicates that we do not want `cloud-init` user data sent as part of this VM Scale Set.  We are **not** setting `vmss_se_settings_script=""` indicating that we want the default VMSS custom script extension script assigned.  This will resolve the [PATH issue](https://www.skidmore.co.uk/post/2022_04_20_azure_devops_vmss_agents_part2/#path-issue) by sending the content of `scripts/vmss_se/vmss-startup.sh`.

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.
