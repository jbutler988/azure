/*+--------------------------
 ||
 ||  Variable Declarations
 ||
 |+-------------------------*/

// Required Variables

variable "backplane_rg_name" {
  description = "Name of the existing backplane resource group."
  /* type        = string */
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// Host Pool Vars

variable "hp_name" {
  description = "Name of the hostpool."
  /* type = string */
}

variable "hp_friendly_name" {
  description = "Friendly name to be displayed for the hostpool"
  /* type = string  */
}

variable "hp_type" {
  description = "The type of the Virtual Desktop Host Pool. Valid options are `Personal` or `Pooled`."
  /* type = string  */
}

variable "hp_load_balancer_type" {
  description = "BreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. Persistent should be used if the host pool type is Personal."
  /* type = string */
}

variable "hp_preferred_app_group_type" {
  description = "Option to specify the preferred Application Group type for the Virtual Desktop Host Pool. Valid options are `None`, `Desktop` or `RailApplications`."
  /* type = string */
}

variable "hp_personal_desktop_assignment_type" {
  description = "`Automatic` assignment – The service will select an available host and assign it to an user. `Direct` Assignment – Admin selects a specific host to assign to an user."
  /* type = string */
}

variable "hp_start_vm_on_connect" {
  description = "Enables or disables the Start VM on Connection Feature."
  /* type = bool */
}

variable "hp_custom_rdp_properties" {
  description = "A valid custom RDP properties string for the Virtual Desktop Host Pool."
  /* type = string  */
}

variable "hp_maximum_sessions_allowed" {
  description = "A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled."
  /* type = number  */
}

variable "hp_mimic_validation_environment" {
  description = "Should the host pool be replicated in a validation environment type?"
  /* type = bool */
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// App Group Vars

variable "app_group_name" {
  description = "The name of the app group."
  /* type = string */
}

variable "app_group_friendly_name" {
  description = "The friendly name for the app group."
  /* type = string */
}

variable "app_group_type" {
  description = "Type of Virtual Desktop Application Group. Valid options are `RemoteApp` or `Desktop` application groups."
  /* type = string */
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

// Workspace Vars

variable "workspace_name" {
  description = "The name of the workspace."
  /* type = string */
}

variable "workspace_friendly_name" {
  description = "The friendly name for the workspace."
  /* type = string */
}



// Optional Variables 

variable "tags" {
  /* type    = map(any) */
  default = {}
}
