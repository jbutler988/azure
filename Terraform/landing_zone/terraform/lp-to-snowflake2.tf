# // Define the resource group

# resource "azurerm_resource_group" "resource_group_eastus2" {
#   name     = "lp-to-snowflake2-${var.ENV}-group-eastus2"
#   location = "East US"
# }

# // Define the storage account
# resource "azurerm_storage_account" "storage_account_eastus2" {
#   name                     = "lp2snwflak2${var.ENV}eastus2"
#   resource_group_name      = azurerm_resource_group.resource_group_eastus2.name
#   location                 = azurerm_resource_group.resource_group_eastus2.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_container" "blob_container_eastus2" {
#   name                  = "jobjobseaastus2"
#   storage_account_name  = azurerm_storage_account.storage_account_eastus2.name
#   container_access_type = "private"
# } 

# // Define the storage queue
# resource "azurerm_storage_queue" "storage_queue_eastus2" {
#   name                 = "jobjobsaastus2"
#   storage_account_name = azurerm_storage_account.storage_account_eastus2.name
# }

# // Define the storage table
# resource "azurerm_storage_table" "storage_table_eastus2" {
#   name                 = "jobjobsaastus2"
#   storage_account_name = azurerm_storage_account.storage_account_eastus2.name
# }

# // Define the app service plan
# resource "azurerm_service_plan" "app_service_plan_eastus2" {
#   name                = "lp-to-snowflake2-${var.ENV}-eastus2"
#   location            = azurerm_resource_group.resource_group_eastus2.location
#   resource_group_name = azurerm_resource_group.resource_group_eastus2.name
#   os_type             = "Linux"
#   sku_name            = "P1v2"
# }

# resource "azurerm_application_insights" "app_insights_eastus2" {
#   name                = "lp-to-snowflake2-${var.ENV}-app-insights-eastus2"
#   location            = azurerm_resource_group.resource_group_eastus2.location
#   resource_group_name = azurerm_resource_group.resource_group_eastus2.name
#   application_type = "other"
# }

# resource "azurerm_linux_function_app" "function_app_eastus2" {
#   name                       = "lp-to-snowflake2-${var.ENV}-eastus2"
#   location                   = azurerm_resource_group.resource_group_eastus2.location
#   resource_group_name        = azurerm_resource_group.resource_group_eastus2.name
#   service_plan_id            = azurerm_service_plan.app_service_plan_eastus2.id
#   storage_account_name       = azurerm_storage_account.storage_account_eastus2.name
#   storage_account_access_key = azurerm_storage_account.storage_account_eastus2.primary_access_key
#   site_config {
#     application_stack {
#       python_version = "3.11"
#     }
#   }
#   app_settings = {
#     "FUNCTIONS_WORKER_RUNTIME" = "python"
#     "WEBSITE_RUN_FROM_PACKAGE" = "1"
#   }
# }


#  resource "azurerm_role_assignment" "storage_roleassignment_eastus2" {
#    scope = azurerm_storage_account.storage_account_eastus2.id
#    role_definition_name = "Storage Blob Data Owner"
#    principal_id = data.azurerm_linux_function_app.fn_wrapper.identity.0.principal_id
#  }
