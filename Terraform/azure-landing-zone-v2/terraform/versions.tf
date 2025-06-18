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
  }
}

provider "azurerm" {
  subscription_id = var.SUB
  features {}
  skip_provider_registration = false
}
