/*+--------------------------
 ||
 ||  Variable Declarations
 ||
 |+-------------------------*/


// Optional Variables

variable "resource_group_prefix" {
  description = "(Optional) Prefix to the various resource groups. Prefixed to `-backplane`."
  type        = string
  default     = "avd-rg"
}

variable "default_location" {
  description = "(Optional) Location for the various resources and resource groups."
  type        = string
  default     = "eastus"
}

variable "disaster_recovery_location" {
  description = "(Optional) Location for disaster recovery resources."
  type        = string
  default     = "southcentralus"
}

variable "base_tags" {
  description = "(Optional) Base tags to be applied to resources."
  type        = map(any)
  default     = {}
}


// AVD Master Config
variable "avd_master_config" {
  description = "AVD Master Config"
  type = object({

    backplanes = map(object({
      // Host Pool Options
      hp_name                             = string
      hp_friendly_name                    = optional(string)
      hp_type                             = string
      hp_load_balancer_type               = optional(string)
      hp_preferred_app_group_type         = optional(string)
      hp_personal_desktop_assignment_type = optional(string)
      hp_start_vm_on_connect              = optional(bool)
      hp_custom_rdp_properties            = optional(string)
      hp_maximum_sessions_allowed         = optional(number)
      hp_mimic_validation_environment     = optional(bool)

      // App Group Options
      app_group_name          = string
      app_group_friendly_name = optional(string)
      app_group_type          = string

      // Workspace Options
      workspace_name = string 
      workspace_friendly_name = optional(string)


      tags = optional(map(string))
    }))
  })
}