<#
.SYNOPSIS
    Migrates an Azure subscription to a new Azure AD tenant.

.DESCRIPTION
    This script migrates an Azure subscription to a new Azure Active Directory (AAD) tenant.
    You must have Owner permissions on the subscription and Global Administrator permissions on both source and target tenants.

.NOTES
    - Ensure you are using the latest Azure PowerShell module.
    - Review Azure documentation for any limitations or prerequisites: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-how-subscriptions-associated-directory
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $true)]
    [string]$TargetTenantId
)

# Set the context to the subscription
Write-Host "Setting context to subscription $SubscriptionId..." -ForegroundColor Cyan
Set-AzContext -SubscriptionId $SubscriptionId -Verbose

# Get current tenant
$currentTenant = (Get-AzContext).Tenant.Id
Write-Host "Current Tenant: $currentTenant" -ForegroundColor Yellow

if ($currentTenant -eq $TargetTenantId) {
    Write-Host "The subscription is already in the target tenant." -ForegroundColor Green
    exit 0
}

# Start migration
Write-Host "Migrating subscription $SubscriptionId to tenant $TargetTenantId..." -ForegroundColor Cyan

try {
    # Change the directory (tenant) of the subscription
    Move-AzSubscription -SubscriptionId $SubscriptionId -DestinationTenantId $TargetTenantId -verbose
    Write-Host "Migration initiated. Please follow up in the Azure Portal to complete any required steps." -ForegroundColor Green
}
catch {
    Write-Error "Migration failed: $_"
}

Write-Host "Script completed." -ForegroundColor Cyan
