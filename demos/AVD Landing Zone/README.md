# Directory Overview

This repository is designed to automatically deploy an Azure landing zone using Terraform. The landing zone should be considered the basic building blocks of an Azure environment designed with a hub and spoke network/workload topology.

## Table of Contents

- [Directory Structure](#directory-structure)
  - [modules Directory](#modules-directory)
- [Variables](#variables)
  - [Shared Variables](#shared-variables)
  - [Network Variables](#network-variables)
  - [Storage Account Variables](#storage-account-variables)
  - [Log Analytics Variables](#log-analytics-variables)
  - [Key Vault Variables](#key-vault-variables)
  - [Bastion Variables](#bastion-variables)

## Directory Structure

### modules Directory

- **bastion_host/**: Module for deploying a Bastion Host.
  - **main.tf**: The main Terraform configuration file for the Bastion Host.
  - **outputs.tf**: Outputs for the Bastion Host module.
  - **variables.tf**: Definitions of variables used in the Bastion Host module.
- **key_vault/**: Module for deploying Key Vaults.
  - **main.tf**: The main Terraform configuration file for the Key Vault.
  - **output.tf**: Outputs for the Key Vault module.
  - **variables.tf**: Definitions of variables used in the Key Vault module.
- **log_analytics/**: Module for Log Analytics configurations.
  - **main.tf**: The main Terraform configuration file for Log Analytics.
  - **output.tf**: Outputs for the Log Analytics module.
  - **variables.tf**: Definitions of variables used in the Log Analytics module.
- **networking/**: Module for networking configurations.
  - **main.tf**: The main Terraform configuration file for networking.
  - **outputs.tf**: Outputs for the networking module.
  - **variables.tf**: Definitions of variables used in the networking module.
- **resource_groups/**: Module for managing resource groups.
  - **main.tf**: The main Terraform configuration file for resource groups.
  - **outputs.tf**: Outputs for the resource groups module.
  - **variables.tf**: Definitions of variables used in the resource groups module.
- **storage/**: Module for storage account configurations.
  - **main.tf**: The main Terraform configuration file for storage accounts.
  - **outputs.tf**: Outputs for the storage accounts module.
  - **variables.tf**: Definitions of variables used in the storage accounts module.

## Variables

### Shared Variables

- **hub_subscription_id**: The subscription ID for the hub.
- **avd_subscription_id**: The subscription ID for the AVD.
- **resource_group_name_prefix**: The prefix for resource group names.
- **resource_group_name_suffix**: The suffix for resource group names.
- **resource_group_names**: A list of resource group names.
- **location**: The location of the resources.
- **tags**: A map of tags to assign to the resources.

### Network Variables

- **desired_resource_group_name**: The name of the resource group for network resources.
- **conn_vnet_name**: The name of the virtual network.
- **conn_vnet_address_space**: The address space of the virtual network.
- **mgmt_vnet_name**: The name of the management virtual network.
- **mgmt_vnet_address_space**: The address space of the management virtual network.
- **conn_subnet_names**: The names of the connection subnets.
- **conn_subnet_address_space**: The address space of the connection subnets.
- **mgmt_subnet_names**: The names of the management subnets.
- **mgmt_subnet_address_space**: The address space of the management subnets.

### Storage Account Variables

- **sa_desired_resource_group_name**: The name of the resource group for storage accounts.
- **storage_account_name**: The name of the storage account.
- **storage_account_tier**: The tier of the storage account.
- **storage_account_replication_type**: The replication type of the storage account.
- **storage_account_kind**: The kind of the storage account.
- **cloud_shell_rg_name**: The name of the resource group for the cloud shell.
- **state_rg_name**: The name of the resource group for the state.

### Log Analytics Variables

- **la_desired_resource_group_name**: The name of the resource group for Log Analytics.
- **log_analytics_workspace_name**: The name of the Log Analytics workspace.
- **log_analytics_workspace_sku**: The SKU of the Log Analytics workspace.
- **log_analytics_workspace_retention_in_days**: The retention period for the Log Analytics workspace.

### Key Vault Variables

- **kv_desired_resource_group_name**: The name of the resource group for the Key Vault.
- **key_vault_name**: The name of the Key Vault.
- **sku_name**: The SKU of the Key Vault.
- **key_vault_enabled_for_deployment**: Whether the Key Vault is enabled for deployment.
- **key_vault_enabled_for_disk_encryption**: Whether the Key Vault is enabled for disk encryption.
- **key_vault_enabled_for_template_deployment**: Whether the Key Vault is enabled for template deployment.
- **key_vault_network_acls**: The network ACLs of the Key Vault.

### Bastion Variables

- **bastion_name**: The name of the Bastion Host.
- **bs_desired_resource_group_name**: The name of the resource group for the Bastion Host.
- **bastion_sku**: The SKU of the Bastion Host.
- **pip_name**: The name of the public IP.
- **pip_sku**: The SKU of the public IP.