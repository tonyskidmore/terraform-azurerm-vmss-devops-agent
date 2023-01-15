# Examples

The examples show how functionality can be achieved by tailoring the deployment of the underlying Virtual Machine Scale Set.

The table below lists the various example contained in the directories below.

| Name                  | Description
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------|
| 001-admin_password    | Minimal example to create an Azure VMSS with admin password and an associated Azure DevOps agent pool.                          |
| 002-certificate_chain | Including a custom certificate chain on the VMSS instance.  Useful if TLS inspection is used e.g. traffic goes through Zscaler. |
| 003-multi-zone        | Deploying agents across availability zones.  Also demonstrates scaling up/down agents on a schedule.                            |
| 004-docker-data-disk  | Adds a data disk and locates the Docker data on that data disk mounted at `/opt/data/docker`                                    |

Each example will have a `*-terraform` pipeline which deploys the scale set based agent pool which should be run first.
There is also an associated `*-test` pipeline that tests the functionality of the deployed agent pool.
The example agent pool and VMSS can be destroyed by re-running the `*-terraform` pipeline and choosing the `terraform-destroy` parameter option.

_Note:_

In most examples VMSS instances are limited to 0 by default to reduce potential costs.
Therefore, there will be a delay of a few minutes (typically 3-5mins depending on the configuration) from when the test pipelines are triggered to when they start executing.
