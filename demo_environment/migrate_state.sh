#!/bin/bash

set -o pipefail

# functions

# TODO: "path": "/demo_environment/backend.tf"
# TODO: branch other than main
create_post_data()
{
  cat <<EOF
{
  "refUpdates": [
    {
      "name": "$current_ref",
      "oldObjectId": "$last_commit"
    }
  ],
  "commits": [
    {
      "comment": "Added terraform backend configuration.",
      "changes": [
        {
          "changeType": "add",
          "item": {
            "path": "/demo_environment/backend.tf"
          },
          "newContent": {
            "content": "$backend_config",
            "contentType": "rawtext"
          }
        }
      ]
    }
  ]
}
EOF
}

build_params() {

  local method="$1"
  local url="$2"

  HTTP_RETRIES=${HTTP_RETRIES:-10}
  HTTP_RETRY_DELAY=${HTTP_RETRY_DELAY:-3}
  HTTP_RETRIES_MAX_TIME=${HTTP_RETRIES_MAX_TIME:-120}
  HTTP_MAX_TIME=${HTTP_MAX_TIME:-120}
  HTTP_CONNECT_TIMEOUT=${HTTP_CONNECT_TIMEOUT:-20}

  # printf "HTTP_RETRIES: %s\n" "$HTTP_RETRIES"
  # printf "HTTP_RETRY_DELAY: %s\n" "$HTTP_RETRY_DELAY"
  # printf "HTTP_RETRIES_MAX_TIME=: %s\n" "$HTTP_RETRIES_MAX_TIME"
  # printf "HTTP_MAX_TIME: %s\n" "$HTTP_MAX_TIME"
  # printf "HTTP_CONNECT_TIMEOUT: %s\n" "$HTTP_CONNECT_TIMEOUT"

  data="$(create_post_data)"

  params=(
          "--silent" \
          "--show-error" \
          "--retry" "$HTTP_RETRIES" \
          "--retry-delay" "$HTTP_RETRY_DELAY" \
          "--retry-max-time" "$HTTP_RETRIES_MAX_TIME" \
          "--max-time" "$HTTP_MAX_TIME" \
          "--connect-timeout" "$HTTP_CONNECT_TIMEOUT" \
          "--write-out" "\n%{http_code}" \
          "--header" "Content-Type: application/json" \
          "--request" "$method"
  )

  if [[ "$method" == "POST" ]]
  then
    # generate curl --data if method if POST(create)
    # mode is global varaiable defined in parent script
    # shellcheck disable=SC2154
    data_func="create_post_data"
    data="$($data_func)"
    # printf "data: %s\n" "$data"
    params+=("--data" "$data")
  fi

  params+=("--user" ":$AZDO_PERSONAL_ACCESS_TOKEN" "$url")

}

rest_api_call() {

  exit_code=0

  if [ "$#" -ne 2 ]
  then
      printf "Expected 2 function arguments, got %s\n" "$#"
      exit 1
  fi

  method="$1"
  url="$2"


  if [[ "$method" == "GET" || "$method" == "POST" ]]
  then
    printf "method: %s\n" "$method"
  else
    printf "Expected method to be one of: GET,POST got %s\n" "$method"
    exit 1
  fi

  if [[ $url =~ ^https:\/\/.+\/_apis.+$ ]]
  then
    printf "url: %s\n" "$url"
  else
    printf "Invalid or missing URL: %s\n" "$url"
    exit 1
  fi

  build_params "$method" "$url"

  # printf "curl %s\n" "${params[*]}"
  res=$(curl "${params[@]}")
  exit_code=$?

  # https://unix.stackexchange.com/questions/572424/retrieve-both-http-status-code-and-content-from-curl-in-a-shell-script
  http_code=$(tail -n1 <<< "$res") # get the last line
  out=$(sed '$ d' <<< "$res") # get all but the last line which contains the status code

  printf "http_code: %s\n" "$http_code"
  printf "out: %s\n" "$out"
  printf "exit_code: %s\n" "$exit_code"

}

# end functions

rg=$(terraform output -raw resource_group_name)
sa=$(terraform output -raw storage_account_name)
cn=$(terraform output -raw container_name)
key=$(terraform output -raw key)
ri=$(terraform output -raw git_repo_id)
proj=$(terraform output -raw ado_project_name)
# needs got installed
current_ref=$(git symbolic-ref HEAD) # refs/heads/main

printf "resource_group_name: %s\n" "$rg"
printf "storage_account_name: %s\n" "$sa"
printf "container_name: %s\n" "$cn"
printf "key: %s\n" "$key"

cp backend.tf.tpl backend.tf

if [[ -n "$rg" && -n "$cn" && -n "$key" ]]
then
  sed -i "s/resource-group-name/${rg}/g" backend.tf
  sed -i "s/container-name/${cn}/g" backend.tf
  sed -i "s/key-name/${key}/g" backend.tf
else
  echo "Error: Could not obtain resource group, container and key names"
  exit 1
fi

if [[ $sa =~ ^sademovmss[0-9]{6}$ ]]
then
  sed -i "s/storage-account-name/${sa}/g" backend.tf
else
  echo "Error: Failed to obtain storage account name"
  exit 1
fi

terraform init -migrate-state -force-copy

# get the last commit from the repo - required for committing new file
commitUrl="$AZDO_ORG_SERVICE_URL/$proj/_apis/git/repositories/$ri/commits?searchCriteria.\$top=1&api-version=6.0"
rest_api_call "GET" "$commitUrl"
last_commit=$(echo "$out" | jq -r '.value[0].commitId')

printf "last_commit: %s\n" "$last_commit"

# commit the backend config to the repository
# backend_config=$(<backend.tf)
backend_config=$(awk '{printf "%s\\n", $0}' backend.tf)
backend_config=${backend_config//\"/\\\"}
poolUrl="$AZDO_ORG_SERVICE_URL/_apis/git/repositories/$ri/pushes?api-version=7.0"
rest_api_call "POST" "$poolUrl"

# to destroy
# rm backend.tf
# terraform init -migrate-state -force-copy
# https://stackoverflow.com/questions/72727023/terraform-warning-warning-use-microsoft-graph-deprecated-this-field-now-d#:~:text=Defaults%20to%20true.%20Note%3A%20In%20Terraform%201.2%20the,Terraform%201.3%2C%20due%20to%20Microsoft%27s%20deprecation%20of%20ADAL.
# plan output being flooded by use_microsoft_graph deprecation warnings
# https://github.com/hashicorp/terraform/issues/31118
