/*+----------------------------------------------------------------------
 ||
 ||  Parent Module - Azure Virtual Desktop in Production - Terraform
 ||
 ||     Author:  Luke Mossburgh, SHI, luke_mossburgh@shi.com
 ||
 ||     Purpose:  Create a production-ready environment for AVD, either 
 ||               net-new or incorporating existing pieces of infrastructure
 ||
 ||     Parent Modules:  None
 ||
 ||     Child Modules:  See `modules` folder
 ||
 |+-----------------------------------------------------------------------
 ||
 ||     Versions:
 ||                 - v0.0.1  August 10, 2021  see Changelog
 ||
 |+-----------------------------------------------------------------------*/


// Create Resource Groups

locals {
  rg_info = {
    "backplane"    = var.default_location
    "network"      = var.default_location
    "fileservices" = var.default_location
    "monitor"      = var.default_location
    "image"        = var.default_location
    "backup"       = var.default_location

    // TODO:  Disaster recovery?

    /* "backplane-DR"    = var.disaster_recovery_location
    "network-DR"      = var.disaster_recovery_location
    "fileservices-DR" = var.disaster_recovery_location
    "monitor-DR"      = var.disaster_recovery_location
    "image-DR"        = var.disaster_recovery_location
    "backup-DR"       = var.disaster_recovery_location */
  }
}

resource "azurerm_resource_group" "avd_resource_groups" {
  for_each = local.rg_info

  name     = format("%s-%s", var.resource_group_prefix, each.key)
  location = each.value

  tags = var.base_tags
}


// AVD Backplane Module (Hostpool, Workspace, App Group, Log Analytics)

module "avd_backplane" {
  for_each = var.avd_master_config.backplanes
  source   = "./modules/avd_backplane"

  // Backplane Resource Group
  backplane_rg_name = azurerm_resource_group.avd_resource_groups["backplane"].name

  // Hostpool Options
  hp_name                             = local.backplanes[each.key].hp_name
  hp_friendly_name                    = local.backplanes[each.key].hp_friendly_name
  hp_type                             = local.backplanes[each.key].hp_type
  hp_load_balancer_type               = each.value.hp_type == "Personal" ? "Persistent" : lookup(each.value, "hp_load_balancer_type", null)
  hp_preferred_app_group_type         = local.backplanes[each.key].hp_preferred_app_group_type
  hp_personal_desktop_assignment_type = each.value.hp_type == "Personal" ? "Automatic" : lookup(each.value, "hp_personal_desktop_assignment_type", null)
  hp_start_vm_on_connect              = local.backplanes[each.key].hp_start_vm_on_connect
  hp_custom_rdp_properties            = local.backplanes[each.key].hp_custom_rdp_properties
  hp_maximum_sessions_allowed         = local.backplanes[each.key].hp_maximum_sessions_allowed
  hp_mimic_validation_environment     = local.backplanes[each.key].hp_mimic_validation_environment
  tags                                = local.backplanes[each.key].tags

  // App Group Options
  app_group_name          = local.backplanes[each.key].app_group_name
  app_group_friendly_name = local.backplanes[each.key].app_group_friendly_name
  app_group_type          = local.backplanes[each.key].app_group_type

  // Workspace Options
  workspace_name = local.backplanes[each.key].workspace_name
  workspace_friendly_name = local.backplanes[each.key].workspace_friendly_name 

  depends_on = [azurerm_resource_group.avd_resource_groups]

}
