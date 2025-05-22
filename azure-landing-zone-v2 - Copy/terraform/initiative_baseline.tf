
# resource "azurerm_management_group_policy_assignment" "baseline" {
#   depends_on           = [ azurerm_policy_set_definition.baseline, azurerm_user_assigned_identity.policy_msi ]
#   name                 = "assign-${azurerm_policy_set_definition.baseline.name}"
#   display_name         = "Baseline Initiative Management Group Assignment ${var.REGION_ABR} ${var.ENV}"
#   management_group_id  = data.azurerm_management_group.mg.id
#   policy_definition_id = azurerm_policy_set_definition.baseline.id
#   location             = var.REGION
#   enforce              = local.settings.enforce_policy
#   identity {
#     type = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.policy_msi.id]

#  }
# }

# # Custom Intiative Definition to deploy diagnostic settings for support PaaS resources to Log Analytics Workspace
# resource "azurerm_policy_set_definition" "baseline" {
#   depends_on          = [ azurerm_storage_account.logs ]
#   name                = ("baseline-${var.REGION_ABR}-${var.ENV}")
#   management_group_id = data.azurerm_management_group.mg.id
#   policy_type         = "Custom"
#   display_name        = "Baseline Security Initiative ${var.REGION_ABR} ${var.ENV}."
#   description         = "Enables baseline for supported resources to Log Analytics workspace or a storage account (where LA isn't supported)"


#   # Allowed Regions
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
#     reference_id = "allowed_locations"
#     parameter_values     = <<VALUE
#     {
#       "listofAllowedLocations": {"value": ["EastUS2","CentralUS","EastUS","WestUS","WestUS2","SouthCentralUS","WestCentralUS"]}
#     }
#     VALUE
#   }

#   # Storage accounts should allow access from trusted Microsoft services
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd"
#     reference_id = "sa_trusted_services"
#   }

#   # Audit VMs that do not use managed disks
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
#     reference_id = "managed_disk_vm_audit"
#   }

#   # Azure Backup should be enabled for Virtual Machines
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
#     reference_id = "backup_vm_audit"
#   }

#   # Blocked accounts with owner permissions on Azure resources should be removed
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0cfea604-3201-4e14-88fc-fae4c427a6c5"
#     reference_id = "blocked_account_owner_permissions_audit"
#   }

#   # Blocked accounts with read and write permissions on Azure resources should be removed
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/8d7e1fde-fe26-4b5f-8108-f8e432cbc2be"
#     reference_id = "blocked_account_rw_permissions_audit"
#   }

#    # Email notification for high severity alerts should be enabled
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6e2593d9-add6-4083-9c9b-4b7d2188c899"
#     reference_id = "enable_high_severity_alert_notification"
#   }

#   # Subscriptions should have a contact email address for security issues
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7"
#     reference_id = "subscription_contact_email_security"
#   }

#   # Email notification to subscription owner for high severity alerts should be enabled
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b15565f-aa9e-48ba-8619-45960f2c314d"
#     reference_id = "enable_owner_alert_notification"
#   }


#   # Enable the Free sku of Microsoft Defender on Subscriptions. Policy will skip if a Standard or Free Sku is already enabled.
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac076320-ddcf-4066-b451-6154267e8ad2"
#     reference_id = "enable_defender_on_subscriptions"
#   }

#   # Subnets should be associated with a Network Security Group
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
#     reference_id = "subnets_should_have_nsg_assigned"
#   }

#   # Accounts with owner permissions on Azure resources should be MFA enabled
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e3e008c3-56b9-4133-8fd7-d3347377402a"
#     reference_id = "mfa_enabled_for_owners"
#   }

#   # Configure secure transfer of data on a storage account
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f81e3117-0093-4b17-8a60-82363134f0eb"
#     reference_id = "secure_data_transfer_config_sa"
#   }

#   # Storage accounts should have the specified minimum TLS version
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0"
#     reference_id = "tls1.2_sa_audit"
#   }

#   # Storage accounts should disable public network access
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
#     reference_id = "sa_disable_public_access_audit"
#   }

#   # System updates should be installed on your machines
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86b3d65f-7626-441e-b690-81a8b71cff60"
#     reference_id = "system_updates_audit"
#   }

#   # Azure Key Vault should disable public network access
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/405c5871-3e91-4644-8a63-58e19d68ff5b"
#     reference_id = "kv_disable_public_access_audit"
#   }

#   # Key vaults should have deletion protection enabled
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
#     reference_id = "kv_purge_protection_audit"
#   }

# }


# ###########
# # Remediation Tasks
# ##########

# resource "azurerm_management_group_policy_remediation" "baseline" {
#   for_each              = local.security_ref_ids
#   depends_on            = [ azurerm_management_group_policy_assignment.logging ]
#   name                  = lower("${each.key}_rem_task")
#   management_group_id  = data.azurerm_management_group.mg.id
#   policy_assignment_id  = azurerm_management_group_policy_assignment.baseline.id
#   policy_definition_reference_id = each.key
# }

# ### Must match the Reference_ID in the policy_definition_reference blocks in the Policy Set Definition Above
# locals {
#   security_ref_ids = toset([
#     "enable_defender_on_subscriptions",
#     "secure_data_transfer_config_sa"
#   ])
# }

