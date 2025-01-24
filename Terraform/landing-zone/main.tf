# Root Module

module "RESOURCE_GROUPS" {
  source                      = "./modules/resource_groups"
  location                    = var.location
  resource_group_name_prefix  = var.resource_group_name_prefix
  resource_group_name_suffix  = var.resource_group_name_suffix
}
# Reminder, remove tags from resource group before deploying to MiTek

module "NETWORKING" {
  source                          = "./modules/networking"
  location                        = var.location
  services_subnet_name            = var.services_subnet_name
  services_subnet_address_prefix  = var.services_subnet_address_prefix
  avd_subnet_name                 = var.avd_subnet_name
  avd_subnet_address_prefix       = var.avd_subnet_address_prefix
  bastion_address_prefix          = var.bastion_address_prefix
  vnet_name                       = var.vnet_name
  vnet_address_space              = var.vnet_address_space
  bastion_subnet_name             = var.bastion_subnet_name
  firewall_subnet_name            = var.firewall_subnet_name
  firewall_subnet_address_prefix  = var.firewall_subnet_address_prefix
  resource_group_name             = module.RESOURCE_GROUPS.PLATFORM_NETWORK_NAME
}

module "DNS" {
  source                              = "./modules/dns"
  location                            = var.location
  resource_group_name                 = module.RESOURCE_GROUPS.PLATFORM_AD_DNS_NAME
  dc_vm_name                          = var.dc_vm_name
  dc_name                             = var.dc_name
  managed_disk_type                   = var.managed_disk_type
  dc_vm_size                          = var.dc_vm_size
  domain_controller_image_sku         = var.domain_controller_image_sku
  domain_controller_image_publisher   = var.domain_controller_image_publisher
  private_dns_zone_names              = var.private_dns_zone_names
  domain_controller_image_offer       = var.domain_controller_image_offer
  domain_controller_image_version     = var.domain_controller_image_version
  dc_admin_username                   = var.dc_admin_username
  dc_admin_password                   = var.dc_admin_password
  subnet_id                           = module.NETWORKING.services_subnet_id
}

module "FIREWALL" {
  source                  = "./modules/firewall"
  location                = var.location
  resource_group_name     = module.RESOURCE_GROUPS.PLATFORM_NETWORK_NAME
  network_id              = module.NETWORKING.vnet_id
  subnet_id               = module.NETWORKING.firewall_subnet_id
  ip_configuration_name   = var.ip_configuration_name
  public_ip_name          = var.public_ip_name
  firewall_name           = var.firewall_name
  firewall_policy_name    = var.firewall_policy_name
}

module "LOG_ANALYTICS" {
  source                        = "./modules/log_analytics"
  location                      = module.RESOURCE_GROUPS.location
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_sku   = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  resource_group_name           = module.RESOURCE_GROUPS.PLATFORM_LOGGING_NAME
}

module "STORAGE" {
  source                            = "./modules/storage"
  location                          = module.RESOURCE_GROUPS.location
  resource_group_name               = module.RESOURCE_GROUPS.PLATFORM_STORAGE_NAME
  storage_account_name              = var.storage_account_name
  storage_account_tier              = var.storage_account_tier
  storage_account_replication_type  = var.storage_account_replication_type
  storage_account_kind              = var.storage_account_kind
  subnet_id                         = module.NETWORKING.services_subnet_id
}

module "AVD" {
  source                      = "./modules/avd"
  location                    = module.RESOURCE_GROUPS.location
  resource_group_name         = module.RESOURCE_GROUPS.PLATFORM_AVD_MANAGEMENT_NAME
  virtual_network_name        = module.NETWORKING.vnet_name
  subnet_name                 = module.NETWORKING.avd_subnet_name
  host_vm_name                = var.host_vm_name
  host_vm_size                = var.host_vm_size
  admin_username              = var.admin_username
  admin_password              = var.admin_password
  avd_workspace_name          = var.avd_workspace_name
  avd_workspace_description   = var.avd_workspace_description
  avd_hostpool_name           = var.avd_hostpool_name
  host_pool_type              = var.host_pool_type
  load_balancer_type          = var.load_balancer_type
  avd_app_group_name          = var.avd_app_group_name
  avd_app_group_type          = var.avd_app_group_type
  subnet_id                   = module.NETWORKING.services_subnet_id
}
