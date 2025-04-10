#!/bin/bash
# DELETE TERRAFORM PRE-REQUISITES


set -euxo pipefail

RG_EXISTS=$(az group exists --name $STATE_RG)
SA_AVAILABLE=$(az storage account check-name --name $STATE_SA | jq -r '.nameAvailable')

# CHECK / DELETE THE RESOURCE GROUP
if [[ $RG_EXISTS = true ]]; then
  az group delete --name $STATE_RG \
                  --yes
else
  echo "Skipping the deletion of the $STATE_RG resource group as it doesn't exist."
fi
