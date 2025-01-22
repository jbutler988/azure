variable "SECRET_ID"{
    default = "na"
}

variable "SUB"{
    type = string
    default = "123"
}

variable "REGION"{
    type = string
    default = "eastus"
}

variable "REGION_ABR"{
    type = string
    default = "eus"
}

variable "ORG"{
    type = string
    default = "org"
}

variable "ENV"{
    type = string
    default = "dev"
}

variable "SVC"{
    type = string
    default = "svc"
}

variable "DEVOPS_ORG"{
    type = string
    default = "devops_org"
}

variable "PAT"{
    type = string
    default = "updatepat"
}

variable "AGENT_POOL"{
    type = string
    default = "pool"
}

variable "DEV_AGENT_POOL"{
    type = string
    default = "ubuntu-lz-eus-dev-pool"
}

variable "VPN_PSK"{
    type = string
    default = "updatepsk"
}

variable "KEY_VAULT_NAME"{
    type = string
    default = "rhp-hub-eus-prod-kv"
}

variable "KEY_VAULT_RG"{
    type = string
    default = "hub-shared-eus-prod-rg"
}

variable "service_principal_object_id" {
  description = "The object ID of the service principal or application that needs access to the Key Vault"
  type        = string
  default = "f3a23f49-6c19-4705-a4f0-da80037b4e84"
}

variable "HUB_SUBSCRIPTION_ID" {
  type        = string
  default = "84d1410c-0939-4d53-ac16-abad3acf18bb"
}

variable "WORKLOAD_SUBSCRIPTION_ID" {
  type        = string
  default = "94cd0abc-cf64-4911-af16-9608392a3cf8"
}

variable "ENTRA_ID" {
    type        = string
    default = "4524f376-8765-42c3-be76-1e7e0171444c"
}