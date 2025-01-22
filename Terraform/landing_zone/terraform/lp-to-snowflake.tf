// Define the resource group

resource "azurerm_resource_group" "resource_group" {
  name     = "lp-to-snowflake-${var.ENV}-group"
  location = "East US"
}

## Following code block sets up a private connection with Azure Key Vault
 // Define the virtual network
 resource "azurerm_virtual_network" "keyvault_vnet" {
   name                = "lp-to-snowflake-${var.ENV}-vnet"
   address_space       = ["10.64.12.0/22"]
   location            = azurerm_resource_group.resource_group.location
   resource_group_name = azurerm_resource_group.resource_group.name
 }
 
 // Define the subnet
 resource "azurerm_subnet" "keyvault_subnet" {
   name                 = "default"
   resource_group_name  = azurerm_resource_group.resource_group.name
   virtual_network_name = azurerm_virtual_network.keyvault_vnet.name
   address_prefixes     = ["10.64.12.0/24"]
 
  service_endpoints = ["Microsoft.KeyVault"]
}
  
 // Define the private DNS zone
 resource "azurerm_private_dns_zone" "key_vault_dns_zone" {
   name                = "privatelink.vaultcore.azure.net"
   resource_group_name = azurerm_resource_group.resource_group.name
 }
 
 // Link the private DNS zone to the virtual network
 resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_dns_zone_link" {
   name                  = "lp-to-snowflake-${var.ENV}-dns-link"
   resource_group_name   = azurerm_resource_group.resource_group.name
   private_dns_zone_name = azurerm_private_dns_zone.key_vault_dns_zone.name
   virtual_network_id    = azurerm_virtual_network.keyvault_vnet.id
 }
 
 // Define the DNS A record for the private endpoint
 resource "azurerm_private_dns_a_record" "key_vault_a_record" {
   name                = azurerm_key_vault.key_vault.name
   zone_name           = azurerm_private_dns_zone.key_vault_dns_zone.name
   resource_group_name = azurerm_resource_group.resource_group.name
   ttl                 = 300
   records             = [azurerm_private_endpoint.key_vault_private_endpoint.private_service_connection[0].private_ip_address]
 }

 
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = "lp-to-snowflake-${var.ENV}-pe"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.keyvault_subnet.id

  private_service_connection {
    name                           = "keyvaultConnection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}


// Define the storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = "lptosnowflake${var.ENV}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

// Define variables for container, queue, and table names
variable "storage_names" {
  type    = list(string)
  default = ["jobjobs", "cstcustomers", "ldsleads", "ilsissuesdleads", "mldmilestonedetail"]
}

// Define the storage containers
resource "azurerm_storage_container" "blob_container" {
  for_each             = toset(var.storage_names)
  name                 = each.value
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

// Define the storage queues
resource "azurerm_storage_queue" "storage_queue" {
  for_each             = toset(var.storage_names)
  name                 = each.value
  storage_account_name = azurerm_storage_account.storage_account.name
}

// Define the storage tables
resource "azurerm_storage_table" "storage_table" {
  for_each             = toset(var.storage_names)
  name                 = each.value
  storage_account_name = azurerm_storage_account.storage_account.name
}

// Define the app service plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = "lp-to-snowflake-${var.ENV}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_application_insights" "app_insights" {
  name                = "lp-to-snowflake-${var.ENV}-app-insights"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type = "other"
}

# data "azurerm_key_vault" "rhp-hub-eus-prod-kv" {
#  name = "${var.KEY_VAULT_NAME}"
#  resource_group_name = "${var.KEY_VAULT_RG}"
# }

# data "azurerm_key_vault_secret" "sql_engine_string" {
#  depends_on = [ azurerm_key_vault_access_policy.service_connection_policy ]
#   name = "h738db-leadperfection-sql-connection-string"
#   key_vault_id = azurerm_key_vault.key-vault.id
# }

# https://github.com/hashicorp/terraform-provider-azurerm/pull/27531 - FC1 plan bug
# // Define the function app
resource "azurerm_linux_function_app" "function_app" {
  name                       = "lp-to-snowflake-${var.ENV}"
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  service_plan_id            = azurerm_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    #"SQL_ENGINE_STRING" = "mssql+pyodbc://h738_rodney:zXQ008!1Kr@h738db.leadperfection.com,1929/h738db?driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
    "SQL_ENGINE_STRING" = data.azurerm_key_vault_secret.sql_engine_string.value
    "BLOB_CONNECTION_STRING" = "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=lptosnowflakeprod;AccountKey=vNOZzmch5j9XX8fUq7wSjggtOMABCRSrYR64fK0ESH3PgVk/H2Pirfvoz+FowUzkUJvfLPVNBhwj+AStDVywng==;BlobEndpoint=https://lptosnowflakeprod.blob.core.windows.net/;FileEndpoint=https://lptosnowflakeprod.file.core.windows.net/;QueueEndpoint=https://lptosnowflakeprod.queue.core.windows.net/;TableEndpoint=https://lptosnowflakeprod.table.core.windows.net/"
    "TABLE_CONNECTION_STRING" = "DefaultEndpointsProtocol=https;AccountName=lptosnowflakeprod;AccountKey=vNOZzmch5j9XX8fUq7wSjggtOMABCRSrYR64fK0ESH3PgVk/H2Pirfvoz+FowUzkUJvfLPVNBhwj+AStDVywng==;EndpointSuffix=core.windows.net"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string
  }
  identity {
    type = "SystemAssigned"
  }
}

# locals {
#   storage_account_endpoint = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.blob_container.name}"
# }

# # Create the function app manually using azapi because of the bug above
# resource "azapi_resource" "flex_function_app" {
#   type = "Microsoft.Web/sites@2023-12-01"
#   name = "lp-to-snowflake-${var.ENV}"
#   #may need to change these to function not rg
#   location = azurerm_resource_group.resource_group.location
#   parent_id = azurerm_resource_group.resource_group.id

#   body = {
#     kind = "functionapp,linux"
#     identity = {
#       type = "SystemAssigned"
#     }
#     properties = {
#       serverFarmId = azurerm_service_plan.app_service_plan.id
#       functionAppConfig = {
#         deployment = {
#           storage = {
#             type = "blobContainer",
#             value = local.storage_account_endpoint
#             authentication = {
#               type = "SystemAssignedIdentity"
#             }
#           }
#         }
#         runtime = {
#           name = "python",
#           version = "3.11"
#         }
#         scaleAndConcurrency = {
#           instanceMemoryMB = 2048
#           maximumInstanceCount = 40
#           triggers = {}
#         }
#       }
#       siteConfig = {
#         appSettings = [
#           {
#             name  = "AzureWebJobsDashboard__accountName"
#             value = azurerm_storage_account.storage_account.name
#           },
#           {
#             name  = "AzureWebJobsStorage__accountName"
#             value = azurerm_storage_account.storage_account.name
#           },
#           {
#             name  = "APPINSIGHTS_INSTRUMENTATIONKEY"
#             value = azurerm_application_insights.app_insights.instrumentation_key
#           },
#           {
#             name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
#             value = azurerm_application_insights.app_insights.connection_string
#           },
#           {
#             name  = "SQL_ENGINE_STRING"
#             # value = data.azurerm_key_vault_secret.sql_engine_string.value
#             value = "mssql+pyodbc://h738_rodney:zXQ008!1Kr@h738db.leadperfection.com,1929/h738db?driver=ODBC+Driver+17+for+SQL+Server"
#           },
#           {
#             name  = "BLOB_CONNECTION_STRING"
#             # value = azurerm_storage_account.storage_account.primary_blob_endpoint
#             value = "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=lptosnowflakeprod;AccountKey=vNOZzmch5j9XX8fUq7wSjggtOMABCRSrYR64fK0ESH3PgVk/H2Pirfvoz+FowUzkUJvfLPVNBhwj+AStDVywng==;BlobEndpoint=https://lptosnowflakeprod.blob.core.windows.net/;FileEndpoint=https://lptosnowflakeprod.file.core.windows.net/;QueueEndpoint=https://lptosnowflakeprod.queue.core.windows.net/;TableEndpoint=https://lptosnowflakeprod.table.core.windows.net/"
#           },
#           {
#             name  = "TABLE_CONNECTION_STRING"
#             # value = azurerm_storage_account.storage_account.primary_table_endpoint
#             value = "DefaultEndpointsProtocol=https;AccountName=lptosnowflakeprod;AccountKey=vNOZzmch5j9XX8fUq7wSjggtOMABCRSrYR64fK0ESH3PgVk/H2Pirfvoz+FowUzkUJvfLPVNBhwj+AStDVywng==;EndpointSuffix=core.windows.net"
#           }
#         ]
#       }
#     }
#   }
# }

# data "azurerm_linux_function_app" "fn_wrapper" {
#   name = azapi_resource.flex_function_app.name
#   resource_group_name = azurerm_resource_group.resource_group.name
# }

resource "azurerm_role_assignment" "storage_roleassignment" {
  scope = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id = azurerm_linux_function_app.function_app.identity[0].principal_id
}

resource "azurerm_role_assignment" "snowflake_roleassignment" {
  scope = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = "d1130253-d904-4a65-8ae1-0903eee928c4" # Snowflake enterprise application: phvsy2snowflakepacint
}

resource "azurerm_eventgrid_event_subscription" "storage_event_subscription" {
  for_each = toset(var.storage_names)
  name     = "lp-to-snowflake-${var.ENV}-${each.value}-event-subscription"
  scope    = azurerm_storage_account.storage_account.id

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.storage_account.id
    queue_name         = azurerm_storage_queue.storage_queue[each.key].name
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
}

resource "azurerm_role_assignment" "snowflake_queue_role_assignment" {
  scope = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id = "db24fba4-e80f-4eec-91e1-faa0789ecdc8" # Snowflake enterprise application: l5bp18snowflakepacint
}