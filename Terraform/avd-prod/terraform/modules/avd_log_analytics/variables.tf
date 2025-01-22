/*+--------------------------
 ||
 ||  Variable Declarations
 ||
 |+-------------------------*/

// Required Variables

variable "la_rg_name" {
    description = "Name of existing log analytics/monitor resource group."
    /* type = string */
}

variable "backplane_rg_name" {
  description = "Name of the existing backplane resource group."
  /* type        = string */
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

 // Log Analytics Variables

variable "la_workspace_name" {
     description = "Name of log analytics workspace."
     /* type = string */
}

variable "la_sku" {
    description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new Sku as of 2018-04-03). Defaults to PerGB2018."
    /* type = string */
}

variable "la_retention_in_days" {
    description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
    /* type = number */
}

variable "la_daily_quota_gb" {
    description = "The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
    /* type = number */
}

variable "la_internet_ingestion_enabled" {
    description = "Should the Log Analytics Workflow support ingestion over the Public Internet? Defaults to true."
    /* type = bool */
}

variable "la_internet_query_enabled" {
    description = "Should the Log Analytics Workflow support querying over the Public Internet? Defaults to true."
    /* type = bool */
}

variable "la_reservation_capacity_in_gb_per_day" {
    description = "The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000."
    /* type = number */
}

    reservation_capacity_in_gb_per_day = var.la_reservation_capacity_in_gb_per_day 

    tags = var.tags


