# Define the variables for your Terraform configuration

## Shared Variables
# Set the Azure subscription ID
#subscription_id     = "620f7fa6-934f-401b-9619-f064dc556cc5" # SHI-Corp-Services-1
subscription_id     = "e0bb7e5f-1bc2-4525-8719-d80996c04508" # SHI-Corp-Services-2

# Define the target Azure region
location = "eastus"       #Allowed values= "eastus", "westus", "centralus", "southcentralus"

# Resource group names
resource_group_name_prefix = "rg-platform-"
resource_group_name_suffix = "-prd-eus-001"


###########################################################################################################################
## Network Variables
# Virtual network name
vnet_name = "vnet-platform-network-prd-eus-001"

# Virtual network address space
vnet_address_space = [
    "10.0.0.0/16"
]

# Subnet variables
bastion_subnet_name     = "AzureBastionSubnet"
bastion_address_prefix  = "10.0.0.0/26"

services_subnet_name            = "snet-platform-services"
services_subnet_address_prefix  = "10.0.5.0/24"


###########################################################################################################################
## AVD Variables

# AVD Admin username
admin_username              = "sysadmin"

# AVD Admin password
admin_password              = "P@ssw0rd1234"

# AVD workspace name
avd_workspace_name          = "ws-platform-avd-prd-eus-001"

# AVD workspace description
avd_workspace_description   = "UPDATE_LATER"

# AVD host pool name
avd_hostpool_name           = "hp-platform-avd-prd-eus-001"

# Host pool type
host_pool_type              = "Pooled"                       #Allowed values= "Pooled", "Personal"

# Load balancer type
load_balancer_type          = "BreadthFirst"                 #Allowed values= "BreadthFirst", "DepthFirst"

# AVD application group name
avd_app_group_name          = "app-platform-avd-prd-eus-001"

# AVD application group type
avd_app_group_type          = "Desktop"                      #Allowed values= "Desktop", "RemoteApp"

# AVD subnet name
avd_subnet_name             = "snet-platform-avd"

# AVD subnet address prefix
avd_subnet_address_prefix   = "10.0.1.0/24"

# Session host VM variables
host_vm_name                = "az01avd001-100"
host_vm_size                = "Standard_D2s_v3"             #Allowed values= "Standard_D2s_v3", "Standard_D4s_v3"
host_vm_image_publisher     = "MicrosoftWindowsDesktop"     #Allowed values= "MicrosoftWindowsDesktop"
host_vm_image_offer         = "Windows-10"                  #Allowed values= "Windows-10"
host_vm_image_sku           = "20h2-evd"                    #Allowed values= "20h2-evd"
host_vm_image_version       = "latest"                      #Allowed values= "latest"
host_vm_managed_disk_type   = "Standard_LRS"                #Allowed values= "Standard_LRS", "Premium_LRS"


###########################################################################################################################
## Storage Account Variables
storage_account_name                = [ "stplatformpeus001" ]
storage_account_tier                = [ "Standard" ]            #Allowed values= "Standard", "Premium"
storage_account_replication_type    = [ "LRS" ]                 #Allowed values= "LRS", "GRS", "RAGRS", "ZRS"
storage_account_kind                = [ "StorageV2" ]           #Allowed values= "StorageV2", "BlobStorage", "FileStorage"


###########################################################################################################################
## Azure Firewall Variables
# public IP variables
public_ip_name                  = "pip-platform-network-prd-eus-001"
public_ip_allocation_method     = "Static"          #Allowed values= "Static", "Dynamic"
public_ip_sku                   = "Standard"        #Allowed values= "Basic", "Standard"

# Azure Firewall variables
firewall_name =                     "afw-platform-network-prd-eus-001"
firewall_sku_tier =                 "Premium"                       #Allowed values= "Standard", "Premium"
firewall_sku_name =                 "AZFW_VNet"                     #Allowed values= "AZFW_VNet", "AZFW_Hub"
ip_configuration_name =             "test_ip_configuration"
firewall_subnet_name =              "AzureFirewallSubnet"
firewall_subnet_address_prefix =    "10.0.10.0/24"

# Azure Firewall Policy variables
firewall_policy_name = "afp-platform-network-prd-eus-001"


###########################################################################################################################
## Log Analytics Workspace Variables
log_analytics_workspace_name                = "law-platform-logging-prd-eus-001"
log_analytics_workspace_sku                 = "PerGB2018"           #Allowed values= "PerGB2018", "Standalone", "PerNode"
log_analytics_workspace_retention_in_days   = 30


###########################################################################################################################
## DNS and AD Variables
# Domain Controller Variables
dc_name = [
    "az01pdc001",
    "az01pdc002"
]

dc_vm_name = [
    "az01pdc001vm",
    "az01pdc002vm"
]

dc_vm_size = [                                      #Allowed values= "Standard_DS2_v2", "Standard_DS3_v2"
    "Standard_DS2_v2",
    "Standard_DS2_v2"
]

dc_admin_username = "sysadmin"
dc_admin_password = "P@ssw0rd1234"

domain_controller_image_publisher   = "MicrosoftWindowsServer"    #Allowed values= "MicrosoftWindowsServer"
domain_controller_image_offer       = "WindowsServer"             #Allowed values= "WindowsServer"
domain_controller_image_sku         = "2019-Datacenter"           #Allowed values= "2019-Datacenter"
domain_controller_image_version     = "latest"                    #Allowed values= "latest"
managed_disk_type                   = "Standard_LRS"              #Allowed values= "Standard_LRS", "Premium_LRS"

# DNS Zone Variables
private_dns_zone_names = [
    "platform.local",
    "platform.com",
    "platform.net",
    "platform.org"
]

private_dns_zone_vnet_link_name = [
    "vnet-link",
    "vnet-link",
    "vnet-link",
    "vnet-link"
]

private_dns_zone_vnet_link_registration_enabled = false
