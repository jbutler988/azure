
resource "azurerm_management_group_policy_assignment" "logging" {
  depends_on           = [ azurerm_policy_set_definition.logging, azurerm_user_assigned_identity.policy_msi ]
  name                 = "assign-${azurerm_policy_set_definition.logging.name}"
  display_name         = "Logging Initiative Management Group Assignment ${var.REGION_ABR} ${var.ENV}"
  management_group_id    = data.azurerm_management_group.mg.id
  policy_definition_id = azurerm_policy_set_definition.logging.id
  location             = var.REGION
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy_msi.id]

 }
}

# Custom Intiative Definition to deploy diagnostic settings for support PaaS resources to Log Analytics Workspace
resource "azurerm_policy_set_definition" "logging" {
  depends_on          = [ azurerm_storage_account.logs ]
  name                = ("logging-${var.REGION_ABR}-${var.ENV}")
  management_group_id = data.azurerm_management_group.mg.id
  policy_type         = "Custom"
  display_name        = "Configure Logging and Diagnostics Initiative ${var.REGION_ABR} ${var.ENV}."
  description         = "Enables Logging for supported resources to Log Analytics workspace or a storage account (where LA isn't supported)"


  # Storage Account Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59759c62-9a22-4cdf-ae64-074495983fef"
    reference_id = "storageaccount_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }
  
  # Blob Storage Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b4fe1a3b-0715-4c6c-a5ea-ffc33cf823cb"
    reference_id = "blob_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Queue Storage Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7bd000e3-37c7-4928-9f31-86c4b77c5c45"
    reference_id = "queue_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

   # Table Storage Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2fb86bf3-d221-43d1-96d1-2434af34eaa0"
    reference_id = "table_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # File Storage Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/25a70cc8-2bd4-47f1-90b6-1478e4662c96"
    reference_id = "file_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Recovery Services Vault Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3"
    reference_id = "rsv_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Key Vault Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47"
    reference_id = "kv_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Defender for Cloud Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9"
    reference_id = "defender_diag_la"
    parameter_values     = <<VALUE
    {
      "resourceGroupName": {"value": "${azurerm_log_analytics_workspace.la.resource_group_name}"},
      "resourceGroupLocation": {"value": "${azurerm_log_analytics_workspace.la.location}"},
      "workspaceResourceId": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Key Vault HSM Diagnostics to Log Analytics Workspace    
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b3884c81-31aa-473d-a9bb-9466fe0ec2a0"
    reference_id = "kv_hsm_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Activity Log Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f"
    reference_id = "activitylog_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"}
    }
    VALUE
  }

  # Configure Azure Monitor Agent for Windows VM's
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ca817e41-e85a-4783-bc7f-dc532d36235e"
    reference_id = "win_vm_ama_deploy"
  }


  # # Windows Data Collection Rule Association Diagnostics to Log Analytics Workspace /providers/Microsoft.Authorization/policyDefinitions/ca817e41-e85a-4783-bc7f-dc532d36235e
  # policy_definition_reference {
  #   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/eab1f514-22e3-42e3-9a1f-e1dc9199355c"
  #   reference_id = "win_vm_dcr_donfig"
  #   parameter_values     = <<VALUE
  #   {
  #     "dcrResourceId": {"value": "${azurerm_monitor_data_collection_rule.win_dcr.id}"}
  #   }
  #   VALUE
  # }

  # Configure Azure Monitor Agent for Linux VM's
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a4034bc6-ae50-406d-bf76-50f4ee5a7811"
    reference_id = "lin_vm_ama_deploy"
  }

  # Linux Data Collection Rule Association Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/58e891b9-ce13-4ac3-86e4-ac3e1f20cb07"
    reference_id = "lin_vm_dcr_config"
    parameter_values     = <<VALUE
    {
      "dcrResourceId": {"value": "${azurerm_monitor_data_collection_rule.lin_dcr.id}"}
    }
    VALUE
  }

  # Virtual Network Gateway Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ed6ae75a-828f-4fea-88fd-dead1145f1dd"
    reference_id = "vnet_gw_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"},
      "categoryGroup": {"value": "allLogs"}
    }
    VALUE
  }

  # Bastion Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f8352124-56fa-4f94-9441-425109cdc14b"
    reference_id = "bastion_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"},
      "categoryGroup": {"value": "allLogs"}
    }
    VALUE
  }

  # Public IP Address Diagnostics to Log Analytics Workspace
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1513498c-3091-461a-b321-e9b433218d28"
    reference_id = "pip_diag_la"
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "${azurerm_log_analytics_workspace.la.id}"},
      "categoryGroup": {"value": "allLogs"}
    }
    VALUE
  }

  # # Configure Flows logs and Traffic Analytics for all Virtual Networks within the same Region ****Still in Preview*****
  # To enable fill out https://aka.ms/VNetflowlogspreviewsignup
  # policy_definition_reference {
  #   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3e9965dc-cc13-47ca-8259-a4252fd0cf7b"
  #   reference_id = "flow_logs_traffic_analytics_config"
  #   parameter_values     = <<VALUE
  #   {
  #     "vnetRegion": {"value": "${var.REGION}"},
  #     "storageId": {"value": "${azurerm_storage_account.logs.id}"},
  #     "networkWatcherRG": {"value": "networkWatcherRG"},
  #     "networkWatcherName": {"value": "networkWatcher_${var.REGION}"},
  #     "workspaceResourceId": {"value": "${azurerm_log_analytics_workspace.la.id}"},
  #     "workspaceRegion": {"value": "${azurerm_log_analytics_workspace.la.location}"}
  #   }
  #   VALUE
  # }

  # Configure Network Security Groups to enable Traffic Analytics
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e920df7f-9a64-4066-9b58-52684c02a091"
    reference_id = "traffic_analytics_on_nsg_config"
    parameter_values     = <<VALUE
    {
      "nsgRegion": {"value": "${var.REGION}"},
      "storageId": {"value": "${azurerm_storage_account.logs.id}"},
      "workspaceResourceId": {"value": "${azurerm_log_analytics_workspace.la.id}"},
      "workspaceRegion": {"value": "${azurerm_log_analytics_workspace.la.location}"},
      "workspaceId": {"value": "${azurerm_log_analytics_workspace.la.workspace_id}"},
      "networkWatcherRG": {"value": "networkWatcherRG"},
      "networkWatcherName": {"value": "networkWatcher_${var.REGION}"}
      
      
    }
    VALUE
  }

  # Deploy network watcher when virtual networks are created
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a9b99dd8-06c5-4317-8629-9d86a3c6e7d9"
    reference_id = "deploy_network_watcher"
  }

}


###########
# Remediation Tasks
##########

resource "azurerm_management_group_policy_remediation" "logging" {
  for_each              = local.policy_ref_ids
  depends_on            = [ azurerm_management_group_policy_assignment.logging ]
  name                  = lower("${each.key}_rem_task")
  management_group_id     = data.azurerm_management_group.mg.id
  policy_assignment_id  = azurerm_management_group_policy_assignment.logging.id
  policy_definition_reference_id = each.key
}

### Must match the Reference_ID in the policy_definition_reference blocks in the Policy Set Definition Above
locals {
  policy_ref_ids = toset([
    "storageaccount_diag_la",
    "blob_diag_la",
    "queue_diag_la",
    "table_diag_la",
    "file_diag_la",
    "rsv_diag_la",
    "kv_diag_la",
    "defender_diag_la",
    "kv_hsm_diag_la",
    "activitylog_diag_la",
    "win_vm_ama_deploy",
    #"win_vm_dcr_config",
    "lin_vm_ama_deploy",
    "lin_vm_dcr_config",
    "vnet_gw_diag_la",
    "bastion_diag_la",
    "pip_diag_la",
    "traffic_analytics_on_nsg_config",
    "deploy_network_watcher"
  ])
}

