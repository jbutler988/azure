
## User MSI for AI resource to resource Authorization

resource "azurerm_user_assigned_identity" "policy_msi" {
  name                = ("msi-${var.SVC}-policy-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.logs.name
}

resource "azurerm_role_assignment" "build_spn" {
  scope                = azurerm_resource_group.shared.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current_client.object_id
}

# Roles required for User Identity to remediate policies
# resource "azurerm_role_assignment" "policy_contrib" {
#   scope                = azurerm_resource_group.test.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.policy_msi.principal_id
# }

# resource "azurerm_role_assignment" "policy_security_admin" {
#   scope                = data.azurerm_management_group.mg.id
#   role_definition_name = "Security Admin"
#   principal_id         = azurerm_user_assigned_identity.policy_msi.principal_id
# }

# resource "azurerm_role_assignment" "policy_la_contrib" {
#   scope                = data.azurerm_management_group.mg.id
#   role_definition_name = "Log Analytics Contributor"
#   principal_id         = azurerm_user_assigned_identity.policy_msi.principal_id
# }

# resource "azurerm_role_assignment" "policy_monitor_contrib" {
#   scope                = data.azurerm_management_group.mg.id
#   role_definition_name = "Monitoring Contributor"
#   principal_id         = azurerm_user_assigned_identity.policy_msi.principal_id
# }





