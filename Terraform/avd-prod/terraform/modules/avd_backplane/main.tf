/*+----------------------------------------------------------------------
 ||
 ||  Child Module - Azure Virtual Desktop in Production - Terraform
 ||
 ||     Author:  Luke Mossburgh, SHI, luke_mossburgh@shi.com
 ||
 ||     Purpose:  Create a production-ready environment for AVD, either 
 ||               net-new or incorporating existing pieces of infrastructure
 ||
 ||     Parent Modules:  Root
 ||
 ||     Child Modules:  avd_log_analytics
 ||
 |+-----------------------------------------------------------------------
 ||
 ||     Versions:
 ||                 - v0.0.1  August 10, 2021  see Changelog
 ||
 |+-----------------------------------------------------------------------*/


// Retrieve Resource Group Data

data "azurerm_resource_group" "avd_backplane_rg" {
  name = var.backplane_rg_name
}


// Create WVD Hostpool(s)
resource "azurerm_virtual_desktop_host_pool" "avd_host_pool" {
  name                = var.hp_name
  friendly_name       = var.hp_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  type                             = var.hp_type
  load_balancer_type               = var.hp_load_balancer_type
  preferred_app_group_type         = var.hp_preferred_app_group_type
  personal_desktop_assignment_type = var.hp_personal_desktop_assignment_type

  start_vm_on_connect  = var.hp_start_vm_on_connect
  validate_environment = false

  # TODO: add ins
  custom_rdp_properties    = var.hp_custom_rdp_properties
  maximum_sessions_allowed = var.hp_maximum_sessions_allowed

  tags = var.tags
}


// Create the mimic'd or replicated validation hostpools
locals {
  hp_validations = {
    (var.hp_name) = var.hp_mimic_validation_environment
  }
}

// Want to get the resource named, rather than a [0] or [1] count
resource "azurerm_virtual_desktop_host_pool" "avd_host_pool_validation" {
  /* count = var.hp_mimic_validation_environment == true ? 1 : 0 */
  for_each = {
    for key, value in local.hp_validations : key => value if value == true
  }

  name                = format("%s-validation", var.hp_name)
  friendly_name       = var.hp_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  type                             = var.hp_type
  load_balancer_type               = var.hp_load_balancer_type
  preferred_app_group_type         = var.hp_preferred_app_group_type
  personal_desktop_assignment_type = var.hp_personal_desktop_assignment_type

  start_vm_on_connect  = var.hp_start_vm_on_connect
  validate_environment = true

  # TODO: Add ins
  custom_rdp_properties    = var.hp_custom_rdp_properties
  maximum_sessions_allowed = var.hp_maximum_sessions_allowed

  tags = var.tags
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// Create App Group(s)

resource "azurerm_virtual_desktop_application_group" "avd_application_group" {

  name                = var.app_group_name
  friendly_name       = var.app_group_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  type         = var.app_group_type
  host_pool_id = azurerm_virtual_desktop_host_pool.avd_host_pool.id

  tags = var.tags

}

// Create App Group for Replication Environment if exists

resource "azurerm_virtual_desktop_application_group" "avd_application_group_validation" {
  for_each = {
    for key, value in local.hp_validations : key => value if value == true
  }

  name                = format("%s-validation", var.app_group_name)
  friendly_name       = var.app_group_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  type         = var.app_group_type
  host_pool_id = azurerm_virtual_desktop_host_pool.avd_host_pool_validation[each.key].id

  tags = var.tags

}


/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// Create Workspace(s)

resource "azurerm_virtual_desktop_workspace" "avd_workspace" {

  name = var.workspace_name
  friendly_name       = var.workspace_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  tags = var.tags

}

// Create Workspace for Replication Environment if exists

resource "azurerm_virtual_desktop_workspace" "avd_workspace_validation" {
  for_each = {
    for key, value in local.hp_validations : key => value if value == true
  }

  name = format("%s-validation", var.workspace_name)
  friendly_name = var.workspace_friendly_name
  resource_group_name = data.azurerm_resource_group.avd_backplane_rg.name
  location            = data.azurerm_resource_group.avd_backplane_rg.location

  tags = var.tags

}

// App Groups associated to Workspaces

resource "azurerm_virtual_desktop_workspace_application_group_association" "avd_ws_app_association" {
  workspace_id = azurerm_virtual_desktop_workspace.avd_workspace.id 
  application_group_id = azurerm_virtual_desktop_application_group.avd_application_group.id 
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "avd_ws_app_association_validation" {
  for_each = {
    for key, value in local.hp_validations : key => value if value == true
  }
  
  workspace_id = azurerm_virtual_desktop_workspace.avd_workspace_validation[each.key].id 
  application_group_id = azurerm_virtual_desktop_application_group.avd_application_group_validation[each.key].id 
}


/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// Nested Module Call for Log Analytics Workspace


