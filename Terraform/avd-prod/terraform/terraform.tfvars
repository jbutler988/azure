avd_master_config = {

  backplanes = {
    "shi-backplane-pooled" = {
      // Host Pool Options
      hp_name                         = "shi-hostpool-pooled"
      hp_type                         = "Pooled"
      hp_load_balancer_type           = "BreadthFirst"
      hp_preferred_app_group_type     = "Desktop"
      hp_start_vm_on_connect          = false
      hp_mimic_validation_environment = true

      // App Group Options
      app_group_name = "shi-hostpool-pooled-desktop-app-group"
      app_group_type = "Desktop"

      // Workspace Options
      workspace_name = "shi-hostpool-pooled-workspace"
    }

    "shi-backplane-personal" = {
      // Host Pool Options
      hp_name          = "shi-hostpool-personal"
      hp_friendly_name = "SHI Hostpool Personal"
      hp_type          = "Personal"

      // App Group Options
      app_group_name = "shi-hostpool-personal-desktop-app-group"
      app_group_type = "Desktop"

      workspace_name = "shi-hostpool-personal-workspace"
    }
  }
}
