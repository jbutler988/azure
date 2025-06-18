<#
.SYNOPSIS
    This PowerShell script queries all Azure subscriptions available to the logged in user and produces a .csv file output with all Azure resources. Additionally, it retrieves all subnets in all virtual networks, all key vaults across the subscriptions and all private endpoints.

.DESCRIPTION
    This PowerShell script queries all Azure subscriptions available to the logged in user and produces a .csv file output with all Azure resources. Additionally, it retrieves all subnets in all virtual networks, all key vaults across the subscriptions and all private endpoints.
    Each subsection creates a separate CSV file in the current directory, detailing the resources, subnets, key vaults, and private endpoints. Follow on management of the output .csv files is required to present a comprehensive view of the Azure environment.

.NOTES
    Author: Jeremy Butler
    Date: 2025-06-12
    Version: 0.5
#>

# Get a list of subscriptions and prompt user to select one
$subscriptions = Get-AzSubscription

###########################################
## Complete Resource Analysis            ##
###########################################

# Initialize an array to hold the resource details with readiness status
$resourceDetails = @()

foreach ($subscription in $subscriptions) {

set-azcontext $subscription.id

# Get the list of resources in the subscription
$resources = Get-AzResource


# Perform analysis for each resource
foreach ($resource in $resources) {
    $resourceType = $resource.ResourceType
    $resourceId = $resource.ResourceId
    
    $resourceDetails += [PSCustomObject]@{
        Name             = $resource.Name
        ResourceGroup    = $resource.ResourceGroupName
        Location         = $resource.Location
        ResourceType     = $resource.ResourceType
        SubscriptionName = $subscription.name
        Subscription     = $subscription.Id
    }
}


# Export resource details to a CSV file in the current directory
$exportFilePath = Join-Path -Path (Get-Location) -ChildPath "Resources.csv"
$resourceDetails | Export-Csv -Path $exportFilePath -NoTypeInformation
Write-Output "Analysis complete. Please check the output above for resource readiness details."
Write-Output "Exported resource list to $exportFilePath"
}


###########################################
## Network and Subnet Analysis           ##
###########################################

$subnetDetails = @()

foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id

    $vnets = Get-AzVirtualNetwork
    foreach ($vnet in $vnets) {
        foreach ($subnet in $vnet.Subnets) {
            $subnetDetails += [PSCustomObject]@{
                VNetName         = $vnet.Name
                SubnetName       = $subnet.Name
                AddressPrefix    = ($subnet.AddressPrefix -join ", ")
                ResourceGroup    = $vnet.ResourceGroupName
                Location         = $vnet.Location
                SubscriptionName = $subscription.Name
                SubscriptionId   = $subscription.Id
            }
        }
    }
}

$subnetExportPath = Join-Path -Path (Get-Location) -ChildPath "Subnets.csv"
$subnetDetails | Export-Csv -Path $subnetExportPath -NoTypeInformation
Write-Output "Exported subnet list to $subnetExportPath"


###########################################
## Key Vault Analysis                    ##
###########################################

$keyVaultDetails = @()
foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id

    $keyVaults = Get-AzKeyVault
    foreach ($keyVault in $keyVaults) {
        $keyVaultDetails += [PSCustomObject]@{
            KeyVaultName     = $keyVault.VaultName
            ResourceGroup    = $keyVault.ResourceGroupName
            Location         = $keyVault.Location
            SubscriptionName = $subscription.Name
            SubscriptionId   = $subscription.Id
        }
    }
}

$keyVaultExportPath = Join-Path -Path (Get-Location) -ChildPath "KeyVaults.csv"
$keyVaultDetails | Export-Csv -Path $keyVaultExportPath -NoTypeInformation
Write-Output "Exported key vault list to $keyVaultExportPath"


###########################################
## Private Endpoint Analysis             ##
###########################################

$privateEndpointDetails = @()
foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id

    $privateEndpoints = Get-AzPrivateEndpoint
    foreach ($pe in $privateEndpoints) {
        $privateEndpointDetails += [PSCustomObject]@{
            PrivateEndpointName = $pe.Name
            ResourceGroup       = $pe.ResourceGroupName
            Location            = $pe.Location
            SubnetId            = $pe.Subnet.Id
            SubscriptionName    = $subscription.Name
            SubscriptionId      = $subscription.Id
        }
    }
}

$privateEndpointExportPath = Join-Path -Path (Get-Location) -ChildPath "PrivateEndpoints.csv"
$privateEndpointDetails | Export-Csv -Path $privateEndpointExportPath -NoTypeInformation
Write-Output "Exported private endpoint list to $privateEndpointExportPath"

###########################################
## Virtual Machine and Data Disk Analysis ##
###########################################

$vmDetails = @()
foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id

    $vms = Get-AzVM
    foreach ($vm in $vms) {
        $dataDisks = $vm.StorageProfile.DataDisks
        if ($dataDisks.Count -eq 0) {
            $vmDetails += [PSCustomObject]@{
                VMName           = $vm.Name
                ResourceGroup    = $vm.ResourceGroupName
                Location         = $vm.Location
                SubscriptionName = $subscription.Name
                SubscriptionId   = $subscription.Id
                DataDiskName     = ""
                DataDiskSizeGB   = ""
                DataDiskLun      = ""
            }
        } else {
            foreach ($disk in $dataDisks) {
                $vmDetails += [PSCustomObject]@{
                    VMName           = $vm.Name
                    ResourceGroup    = $vm.ResourceGroupName
                    Location         = $vm.Location
                    SubscriptionName = $subscription.Name
                    SubscriptionId   = $subscription.Id
                    DataDiskName     = $disk.Name
                    DataDiskSizeGB   = $disk.DiskSizeGB
                    DataDiskLun      = $disk.Lun
                }
            }
        }
    }
}

$vmExportPath = Join-Path -Path (Get-Location) -ChildPath "VMsAndDataDisks.csv"
$vmDetails | Export-Csv -Path $vmExportPath -NoTypeInformation
Write-Output "Exported VM and data disk list to $vmExportPath"
