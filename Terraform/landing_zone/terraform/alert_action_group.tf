


# resource "azurerm_monitor_action_group" "main" {
#   name                = "Azure_Admins_Email"
#   resource_group_name = azurerm_log_analytics_workspace.la.resource_group_name
#   short_name          = "dflt_email"

#   email_receiver {
#     name          = "Azure_Admins"
#     email_address = "devopsalerts@shi.com"
#   }
# }