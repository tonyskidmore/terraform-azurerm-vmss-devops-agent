#!/bin/bash

set -o pipefail

mv backend.tf.sample backend.tf
sa=$(terraform output -raw storage_account_name)

if [[ $sa =~ ^sademovmss[0-9]{8}$ ]]
then
  sed -i 's/storage-account-name/${sa}/g' backend.tf
  terraform init -migrate-state -force-copy
else
  echo "Error: Failed to obtain storage account name"
  exit 1
fi
