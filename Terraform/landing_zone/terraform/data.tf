data "azurerm_client_config" "current_client" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "mg" {
  name = "RHP-${var.ENV}"
}

data "azurerm_management_group" "hub" {
  name = "RHP-HUB-${var.ENV}"
}

data "azurerm_key_vault_secret" "sql_engine_string" {
  name         = "h738db-leadperfection-sql-connection-string"
  key_vault_id = azurerm_key_vault.key_vault.id
}