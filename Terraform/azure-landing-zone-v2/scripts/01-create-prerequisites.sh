#!/bin/bash
# GENERATE TERRAFORM PRE-REQUISITES

set -exo pipefail

#SA_REGION=$1
az login --service-principal -u $servicePrincipalId -p $servicePrincipalKey --tenant $TENANT_ID

az account set --subscription $TF_VAR_SUB


# CHECK / CREATE THE RESOURCE GROUP

if [ $(az group exists --name $STATE_RG) = false ]; then
  echo "Creating Resource Group for State File"
  az group create --name $STATE_RG --location $TF_VAR_REGION
else
  echo "Skipping the creation of the $STATE_RG resource group as it already exists."
fi

# CHECK / CREATE THE STORAGE ACCOUNT
SA_AVAILABLE=$(az storage account check-name --name $STATE_SA | jq -r '.nameAvailable')
if [[ $SA_AVAILABLE = true ]]; then
echo "Creating Storage Acount $STATE_SA"
az storage account create --name $STATE_SA --resource-group $STATE_RG --location $TF_VAR_REGION --sku Standard_ZRS
else
  echo "Skipping Creation of Storage Account $STATE_SA because it already exists or an error is preventing creation"
fi

SA_KEY=$(az storage account keys list --account-name $STATE_SA --resource-group $STATE_RG | jq -r '.[0].value')
SC_EXISTS=$(az storage container exists --name tfstate --account-name $STATE_SA --account-key $SA_KEY | jq -r '.exists')

# CHECK / CREATE THE STORAGE CONTAINER
if [[ $SC_EXISTS = false ]]; then
  echo "Creating TFState Container"
  az storage container create --name tfstate --account-name $STATE_SA --account-key $SA_KEY --resource-group $STATE_RG
else
  echo "Skipping the creation of the tfstate container as it already exists."
fi
