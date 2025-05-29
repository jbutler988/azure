<#
.SYNOPSIS
    This PowerShell script queries all Azure subscriptions available to the logged in user and produces a .csv file output with all Azure resources.

.DESCRIPTION
    This script is designed to query all available subscriptions within an Azure tenant for resources currently.
    The script will output a .csv file with the following columns: Name, Resource Group, Location, Resource Type, SubscriptionName, and Subscription.

.NOTES
    Author: Jeremy Butler
    Date: 2021-09-27
    Version: 0.1
#>

# Get a list of subscriptions and prompt user to select one
$subscriptions = Get-AzSubscription

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
$exportFilePath = Join-Path -Path (Get-Location) -ChildPath "CspResources.csv"
$resourceDetails | Export-Csv -Path $exportFilePath -NoTypeInformation
Write-Output "Analysis complete. Please check the output above for resource readiness details."
Write-Output "Exported resource list to $exportFilePath"
}


# Get all subnets in all virtual networks
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

$subnetExportPath = Join-Path -Path (Get-Location) -ChildPath "CspSubnets.csv"
$subnetDetails | Export-Csv -Path $subnetExportPath -NoTypeInformation
Write-Output "Exported subnet list to $subnetExportPath"


# Get all key vaults in all subscriptions
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

$keyVaultExportPath = Join-Path -Path (Get-Location) -ChildPath "CspKeyVaults.csv"
$keyVaultDetails | Export-Csv -Path $keyVaultExportPath -NoTypeInformation
Write-Output "Exported key vault list to $keyVaultExportPath"
