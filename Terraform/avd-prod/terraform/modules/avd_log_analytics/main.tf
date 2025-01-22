/*+----------------------------------------------------------------------
 ||
 ||  Child Module - Azure Virtual Desktop in Production - Terraform
 ||
 ||     Author:  Luke Mossburgh, SHI, luke_mossburgh@shi.com
 ||
 ||     Purpose:  Create a production-ready environment for AVD, either 
 ||               net-new or incorporating existing pieces of infrastructure
 ||
 ||     Parent Modules:  Root -> avd_backplane
 ||
 ||     Child Modules:  avd_monitor
 ||
 |+-----------------------------------------------------------------------
 ||
 ||     Versions:
 ||                 - v0.0.1  August 11, 2021  see Changelog
 ||
 |+-----------------------------------------------------------------------*/


 // Retrieve Resource Group Data

data "azurerm_resource_group" "la_rg" {
  name = var.la_rg_name
}

data "azurerm_resource_group" "avd_backplane_rg" {
    name = var.backplane_rg_name
}

 // Create Log Analytics Workspace

resource "azurerm_log_analytics_workspace" "la_workspace" {

    name = var.la_workspace_name
    resource_group_name = data.azurerm_resource_group.la_rg_name.name
    location = data.azurerm_resource_group.la_rg_name.location

    sku = var.la_sku 

    retention_in_days = var.la_retention_in_days
    daily_quota_gb = var.la_daily_quota_gb 

    internet_ingestion_enabled = var.la_internet_ingestion_enabled
    internet_query_enabled = var.la_internet_query_enabled
    reservation_capacity_in_gb_per_day = var.la_reservation_capacity_in_gb_per_day 

    tags = var.tags
}