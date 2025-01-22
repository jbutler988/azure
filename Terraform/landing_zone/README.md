# Table of Contents
- [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Basic Workflow Instructions](#basic-workflow-instructions)
    - [Code Modification Process](#code-modification-process)
    - [How to Target Different Subscriptions with Landing Zone Pipeline](#how-to-target-different-subscriptions-with-landing-zone-pipeline)
  - [Directory Functions and Structure](#directory-functions-and-structure)
  - [Common Errors](#common-errors)
 

## Introduction
This code repository is designed to automatically deploy an Azure landing zone. The landing zone should be considered the basic building blocks of an Azure environment designed with a hub and spoke network / workload topology. This repository is not

## Basic Workflow Instructions
### Code Modification Process 
1.	The infrastructure is managed using a combination of YAML and Terraform. Variables are defined in settings.yaml for the Hub resources such as VNETs and subnets, VPN Public IPs, VPN Prefix and count of VMs to deploy.
2.	To commit changes, you can either edit the code directly in the Azure DevOps portal or clone the Repo to Visual Studio Code. 
3.	Once the changes are committed, the pipeline runs a plan and applies to the target subscriptions as defined in the pipeline.yaml file.
For additional context and a more rich walkthrough, please reference the Azure Landing Zone Build Document.

### How to Target Different Subscriptions with Landing Zone Pipeline
At the time of deployment, inside the 'Pipelines' tab of Azure DevOps, follow the following steps to deploy the pipeline against different subscriptions. In the case of this landing zone repo, 'Dev' subscription or 'Prod' subscription:
1. Click on the 'Landing_Zone' pipeline that is already created.
2. Click on the blue 'Run pipeline' button on the upper right side of the screen.
    At this point, you will be able to change many of the parameters defined in the pipeline. For now, lets focus on the subscription we want to deploy to.
3. Look for the 'Environment' parameter. Options include 'Dev' and 'Prod'. As Renovo's cloud adoption jeorney matures, additional options may become available such as: 'Test', 'Stage' or more.
4. Select among the options what environment you want to deploy to.
    If needed, double check the subscription ID against what you expect by looking for the 'env' parameter.
5. Click the blue 'Run' button at the bottom of the blade and allow the pipeline to run.

<<<<<<< HEAD
=======
Note: If managing a new subscription, a small edit to the pipeline.yml must be made to avoid errors with deployment. Please reference [Common Errors section, subsection 6](#common-errors) for directions on targeting a net new landing zone in a new subscription.

>>>>>>> 5174007adf48263c95a275cb9cabeb37fd41767b
## Directory Functions and Structure
    Landing_Zone (Root directory for the Terraform code and the Landing_Zone repo)
    | environments - this directory contains all the parameter values for each environment and region
    || dev - this sub-directory houses information for a pipeline to deploy a dev landing zone.
    || prod - this sub-directory houses information for a pipeline to deploy a production landing zone.
    ||| eastus / centralus - this sub-directory contains settings.yaml files for declairing what Azure region to deploy to.
    | pipelines - this directory contains a yaml pipeline for deployment and a yaml pipeline for destroying what was build be the deployment yaml pipeline.
    | scripts - this directory houses all the bash scripts to install and uninstall any prereqs that may exist.
    | terraform - this directory contains all the information regarding any resources Renovo may see fit to deploy for an Azure landing zone.

## Common Errors
1.  "Error: name ("[STORAGE ACCOUNT NAME]") can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long":
        This error happens when attempting to deploy an Azure storage account. Storage accounts can only contain lowercase letters and numbers and must be globally unique. That is, if one storage account has a name of 'storageaccount1234' in uswest region in subscription 1, you may not have a storage account with the same name even if it is in a different subscription, in a different region.
<<<<<<< HEAD
=======

>>>>>>> 5174007adf48263c95a275cb9cabeb37fd41767b
2.  "Error: making Read request on Azure KeyVault Secret devops-pat: keyvault.BaseClient#GetSecret: Failure responding to request: StatusCode=403...":
        This error happens when a service principal running a deployment pipeline attempts to access a secret stored inside an Azure key vault. In order to list and read secrets inside a key vault, the service principal must have one of the following role assignment in addition to any other roles required to deploy infrastructure (ie: contributor):
            1.  "Key vault secrets user" -- This role is used to list and read secret values inside a key vault. This role is good for achieving least priviledge from a built in role assignment.
            2.  "Key vault secrets officer" -- This role is not recommended for any service principal that is access a key vault to retrieve a secret. This role should only be used for any user or service principal to administer the key vault. Least priviledge dictates this role should be use sparingly.
            3.  Custom role -- This option, though technically difficult to achieve exactly the effect desired, is the best option for least privilege. It allows kay vault admins to define exactly what a user or service principal can access.
<<<<<<< HEAD
=======
            4.  
>>>>>>> 5174007adf48263c95a275cb9cabeb37fd41767b
3. "Error: failed to read provider configuration schema for registry.terraform.io/hashicorp/random: failed to instantiate provider 
    "registry.terraform.io/hashicorp/random" to obtain schema: unavailable provider "registry.terraform.io/hashicorp/random" :
        This error happens when the pipeline attempts to generate a random passwork for a virtual machine local admin login credentials. To resolve this error, make sure the following provider is in the version.tf file:
            random = {
                source = "hashicorp/random"
                version = ">= 3.0"
            }
<<<<<<< HEAD
=======

>>>>>>> 5174007adf48263c95a275cb9cabeb37fd41767b
4. "Error: Saved plan is stale 
    │ 
    │ The given plan file can no longer be applied because the state was changed 
    │ by another operation after the plan was created. 
    " :
        This error occures when changes were made to the terraform code base somewhere. Terraform registers a change when compairing the build.tf against the declaired environment. To resolve simply rerun a tf build command or rerun the pipeline instead of rerun error code.
<<<<<<< HEAD
=======

5.  "Error: making Read request on Azure KeyVault Secret h738db-leadperfection-sql-connection-string: keyvault.BaseClient#GetSecret: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned  an      error. Status=403 Code="Forbidden" Message="Public network access is disabled and request is not from a trusted service nor via an approved private link.\r\nCaller: appid=***;oid=f3a23f49-6c19-4705-a4f0-da80037b4e84;iss=https://sts.windows.net/4524f376-8765-42c3-be76-1e7e0171444c/\r\nVault: rhp-hub-eus-prod-kv;location=eastus" InnerError={"code":"ForbiddenByConnection"}
        This error occures when an application is not configured properly. The application must be configured to access the vnet to access the key vault, as the key vault is configured not to accept traffic from any public networks. Please see the following link for more information: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app#key_vault_reference_identity_id-2

6.  "There was a resource authorization issue: "The pipeline is not valid. Could not find a pool with name ubuntu-lz-cus-dev-pool. The pool does not exist or has not been authorized for use. For authorization details, refer to https://aka.ms/yamlauthz. Could not find a pool with name ubuntu-lz-cus-dev-pool. The pool does not exist or has not been authorized for use. For authorization details, refer to https://aka.ms/yamlauthz."

![Error for net new LZ](.\readme_resources\Error%20for%20net%20new%20LZ.png)

        This error occurs when attempting to build a net new landing zone. The error is a result of the deployment code attempting to utilize a private agent pool for the pipeline build that does not exist yet.
        To remediate this error, the following changes must be made to the YAML pipeline:
            Inside .\LANDING_ZONE\pipelines\pipeline.yml line 92, change the code from:

                pool: $(TF_VAR_AGENT_POOL)
                  #vmImage: 'ubuntu-20.04'

                to

                pool: #$(TF_VAR_AGENT_POOL)
                  vmImage: 'ubuntu-20.04'
        
        This will force the pipeline to utilize a platform provided agent to deploy the landing zone. Once the pipeline has ran one time revert the changes made above to utilize the new private agent pool to achieve a more responsive pipeline.
>>>>>>> 5174007adf48263c95a275cb9cabeb37fd41767b
