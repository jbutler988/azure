
# resource "azurerm_management_group_policy_assignment" "tagging" {
#   depends_on           = [ azurerm_policy_set_definition.tagging, azurerm_user_assigned_identity.policy_msi ]
#   name                 = "asgn-${azurerm_policy_set_definition.tagging.name}"
#   display_name         = "tagging Initiative Management Group Assignment ${var.REGION_ABR}"
#   management_group_id  = data.azurerm_management_group.hub.id
#   policy_definition_id = azurerm_policy_set_definition.tagging.id
#   location             = var.REGION
#   identity {
#     type = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.policy_msi.id]

#  }
# }

# # Custom Intiative Definition to deploy diagnostic settings for support PaaS resources to Log Analytics Workspace
# resource "azurerm_policy_set_definition" "tagging" {
#   depends_on          = [ azurerm_storage_account.logs ]
#   name                = ("${var.REGION_ABR}-${var.ENV}-tagging")
#   management_group_id = data.azurerm_management_group.hub.id
#   policy_type         = "Custom"
#   display_name        = "Configure tagging and Diagnostics Initiative."
#   description         = "Enables tagging for supported resources to Log Analytics workspace or a storage account (where LA isn't supported)"


#   # Creates a Cost Center tag at the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96d9a89c-0d67-41fc-899d-2b9599f76a24"
#     reference_id = "costcenter"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "CostCenter"},
#       "tagValue": {"value": "${local.settings.costcenter_tag}"}

#     }
#     VALUE
#   }
#   # Creates an Owner tag at the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96d9a89c-0d67-41fc-899d-2b9599f76a24"
#     reference_id = "owner"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "Owner"},
#       "tagValue": {"value": "${local.settings.owner_tag}"}

#     }
#     VALUE
#   }
#   # Creates a Team tag at the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96d9a89c-0d67-41fc-899d-2b9599f76a24"
#     reference_id = "team"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "Team"},
#       "tagValue": {"value": "${local.settings.team_tag}"}

#     }
#     VALUE
#   }
#   # Creates an Environment tag at the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96d9a89c-0d67-41fc-899d-2b9599f76a24"
#     reference_id = "environment"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "environment"},
#       "tagValue": {"value": "${var.ENV}"}

#     }
#     VALUE
#   }
#   # Inherits the Cost Center tag from the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b27a0cbd-a167-4dfa-ae64-4337be671140"
#     reference_id = "inherit_costcenter"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "cost_center"}
#     }
#     VALUE
#   }
#   # Inherits the Owner tag from the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b27a0cbd-a167-4dfa-ae64-4337be671140"
#     reference_id = "inherit_owner"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "owner"}
#     }
#     VALUE
#   }
#   # Inherits the team tag from the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b27a0cbd-a167-4dfa-ae64-4337be671140"
#     reference_id = "inherit_team"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "team"}
#     }
#     VALUE
#   }
#   # Inherits the environment tag from the subscription level
#   policy_definition_reference {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b27a0cbd-a167-4dfa-ae64-4337be671140"
#     reference_id = "inherit_environment"
#     parameter_values     = <<VALUE
#     {
#       "tagName": {"value": "environment"}
#     }
#     VALUE
#   }
# }


# ###########
# # Remediation Tasks
# ##########

# resource "azurerm_management_group_policy_remediation" "tagging" {
#   for_each              = local.tagging_ref_ids
#   depends_on            = [ azurerm_management_group_policy_assignment.tagging ]
#   name                  = lower("${each.key}_rem_task")
#   management_group_id   = data.azurerm_management_group.hub.id
#   policy_assignment_id  = azurerm_management_group_policy_assignment.tagging.id
#   policy_definition_reference_id = each.key
# }

# ### Must match the Reference_ID in the policy_definition_reference blocks in the Policy Set Definition Above
# locals {
#   tagging_ref_ids = toset([
#     "costcenter",
#     "owner",
#     "environment",
#     "team",
#     "inherit_costcenter",
#     "inherit_owner",
#     "inherit_environment",
#     "inherit_team"
#   ])
# }

