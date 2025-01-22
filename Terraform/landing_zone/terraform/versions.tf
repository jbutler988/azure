locals {
  settings = yamldecode(file("../environments/${var.ENV}/${var.REGION}/settings.yaml"))
}

terraform {
  backend "azurerm" {
    # Configured in pipeline script
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  subscription_id = var.SUB
  features {}
}

# provider "azurerm" {
#   alias = "example"
#   subscription_id = local.settings.second_subscription_id
#   features {}
# }
