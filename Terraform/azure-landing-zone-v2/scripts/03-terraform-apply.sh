#!/bin/bash
# TERRAFORM APPLY

set -exo pipefail

ENVIRONMENT=$1
STATE_LOCATION=$2

export ARM_CLIENT_ID=$servicePrincipalId
export ARM_CLIENT_SECRET=$servicePrincipalKey
export ARM_TENANT_ID=$TENANT_ID
export ARM_SUBSCRIPTION_ID=$TF_VAR_SUB

cd terraform
  terraform version
  terraform init -backend-config=resource_group_name=$STATE_RG \
                 -backend-config=storage_account_name=$STATE_SA \
                 -backend-config=container_name="tfstate" \
                 -backend-config=key="terraform.state" \
                 -no-color \
                 -input=false
  terraform workspace select $WORKSPACE || terraform workspace new $WORKSPACE
  terraform apply -input=false \
                  -auto-approve "$ARTIFACT_DIRECTORY/plan/out.plan"
cd ..
