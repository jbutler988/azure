# Root Module

module "RESOURCE_GROUPS" {
  source = "./modules/resource_groups"
  resource_group_name = var.resource_group_name
  location = var.location
  tags = var.tags  
}

module "AVD-WORKSPACE" {
  source                      = "./modules/avd-workspace"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tags                        = var.tags
  avd_workspace_name          = var.avd_workspace_name
  avd_workspace_description   = var.avd_workspace_description
  depends_on                  = [ module.RESOURCE_GROUPS ]  
}

module "AVD-POOLED" {
  source                      = "./modules/avd-pooled"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tags                        = var.tags
  avd_workspace_name          = var.avd_workspace_name
  avd_workspace_description   = var.avd_workspace_description
  avd_hostpool_name_prefix_pooled   = var.avd_hostpool_name_prefix_pooled
  load_balancer_type          = var.load_balancer_type
  avd_app_group_name          = var.avd_pooled_app_group_name
  avd_app_group_type          = var.avd_pooled_app_group_type
  depends_on                  = [ module.RESOURCE_GROUPS ]
}

module "AVD-PERSONAL" {
  source                      = "./modules/avd-personal"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tags                        = var.tags
  avd_workspace_name          = var.avd_workspace_name
  avd_workspace_description   = var.avd_workspace_description
  avd_hostpool_name_prefix_personal   = var.avd_hostpool_name_prefix_personal
  load_balancer_type          = var.load_balancer_type
  avd_app_group_name          = var.avd_personal_app_group_name
  avd_app_group_type          = var.avd_personal_app_group_type
  depends_on                  = [ module.RESOURCE_GROUPS ]
}
