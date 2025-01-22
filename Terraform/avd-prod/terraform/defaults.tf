locals {
  backplanes = defaults(var.avd_master_config.backplanes, {
    hp_preferred_app_group_type     = "Desktop"
    hp_mimic_validation_environment = false
  })
}