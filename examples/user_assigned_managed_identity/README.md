# Example - Create Azure DevOps Scale Set using User Assigned Managed Identity

In this example we are creating a pool named `vmss-mkt-image-003` based on an Azure MarketPlace Ubuntu 20.04 image.

We are not setting `ado_pool_*` variables, so we will get the default settings for the pool.

In this slightly contrived example we are creating an Azure Key Vault and allowing access to a User Assigned Managed Identity that is assigned the VMSS.  Normally a Service Connection in Azure DevOps would be used to access Key Vault secret with the [Azure Key Vault task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-key-vault).  In the example below we gain access to the required secret using curl and the (Azure Key Vault Get Secret REST API)[https://learn.microsoft.com/en-us/rest/api/keyvault/secrets/get-secret/get-secret?source=recommendations&tabs=HTTP] using the managed identity, this would be executed as part of a bash script in an Azure DevOps Pipeline, for example:

````YAML

---

parameters:

  - name: poolName
    type: string
    default: 'vmss-mkt-image-003'
  - name: buildIndex
    type: string


trigger: none

stages:

  - stage: 'Secret'
    pool:
      name: ${{ parameters.poolName }}
    displayName: "Get Secret"

    jobs:

      - job: key_vault
        timeoutInMinutes: 30
        workspace:
          clean: all

        steps:

          - script: |
              sudo apt update
              sudo apt install -y jq
            displayName: 'Install jq'

          - script: |
              response=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-08-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true -s)
              access_token=$(echo $response | jq -r .access_token)
              secret_response=$(curl -s -X GET -H "Authorization: Bearer $access_token" https://kv-${INDEX}-example.vault.azure.net/secrets/admin-password?api-version=7.3)
              secret=$(echo $secret_response | jq -r .value)
              printf "secret: %s\n" "$secret"
            displayName: 'Get admin-password'
            env:
              INDEX: ${{ parameters.buildIndex }}

````

Obviously you wouldn't just obtain the password and print it out in a pipeline, it just serves to demonstrate the mechanism of how a managed identity can be used.

Reference:
[How to use managed identities for Azure resources on an Azure VM to acquire an access token](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token)

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.
