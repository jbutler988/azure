data "azurerm_client_config" "current_client" {}

data "azurerm_subscription" "current" {}


data "azurerm_management_group" "mg" {
  name = "mg-shi-lz-test"
}

data "azurerm_management_group" "hub" {
  name = "mg-production-shi-landing-zone-test"
}