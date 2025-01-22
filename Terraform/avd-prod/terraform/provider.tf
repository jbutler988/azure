/*+--------------------------
 ||
 ||  Provider Declarations
 ||
 |+-------------------------*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.71.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}