<#
.SYNOPSIS
    This PowerShell script searches the source Azure subscription for all Entra role assignments and custom roles. It also reports all Key Vaults and their access policies, as well as all resources with known Entra directories (Azure AD tenants).

.DESCRIPTION
    This PowerShell script searches the source Azure subscription for all Entra role assignments and custom roles. It also reports all Key Vaults and their access policies, as well as all resources with known Entra directories (Azure AD tenants).

.NOTES
    Author: Jeremy Butler
    Date: 2025-04-25
    Version: 0.1
#>

# Specify the subscription ID
$subscriptionId = "1dc888f8-76e4-4a68-9b19-750b42aa1acf"

# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Get all role assignments for the subscription
$roleAssignments = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId"

# Define the output CSV file path
$outputCsvPath = "keyvaultRoleAssignments.csv"

# Export role assignments to CSV
$roleAssignments | Select-Object `
    RoleAssignmentName, `
    DisplayName, `
    SignInName, `
    ObjectType, `
    RoleDefinitionName, `
    PrincipalType, `
    Scope `
    | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Role assignments exported to $outputCsvPath"

#############################################################################################################

# Get all custom roles for the subscription
$customRoles = Get-AzRoleDefinition | Where-Object { $_.IsCustom -eq $true }

# Define the output CSV file path for custom roles
$customRolesCsvPath = "customRoles.csv"

if ($null -eq $customRoles) {
    Write-Host "No custom roles found in the subscription."
}

else {
# Export custom roles to CSV
$customRoles | Select-Object `
    Name, `
    Description, `
    Actions, `
    NotActions, `
    AssignableScopes `
    | Export-Csv -Path $customRolesCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Custom roles exported to $customRolesCsvPath"
}

#############################################################################################################

# Get all role assignments for managed identities
$managedIdentityRoleAssignments = $roleAssignments | Where-Object { $_.PrincipalType -eq "ServicePrincipal" -and $_.DisplayName -like "msi*" }

# Define the output CSV file path for managed identity role assignments
$managedIdentityCsvPath = "managedIdentityRoleAssignments.csv"

if ($null -eq $managedIdentityRoleAssignments) {
    Write-Host "No managed identity role assignments found in the subscription."
}

else {
# Export managed identity role assignments to CSV
$managedIdentityRoleAssignments | Select-Object `
    DisplayName, `
    RoleDefinitionName, `
    PrincipalType, `
    Scope, `
    Id `
    | Export-Csv -Path $managedIdentityCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Managed identity role assignments exported to $managedIdentityCsvPath"
}

#############################################################################################################

# Get all Key Vaults in the subscription
$keyVaults = Get-AzKeyVault -SubscriptionId $subscriptionId

if ($null -eq $keyVaults) {
    Write-Host "No Key Vaults found in the subscription."
} else {
    # Define the output CSV file path for Key Vaults and their access policies
    $keyVaultsCsvPath = "keyVaultsWithAccessPolicies.csv"

    # Combine Key Vault details with access policies or role assignments
    $keyVaultsWithAccessPolicies = foreach ($vault in $keyVaults) {
        if ($vault.AccessPolicies) {
            # Traditional access policies
            foreach ($policy in $vault.AccessPolicies) {
                [PSCustomObject]@{
                    VaultName               = $vault.VaultName
                    ResourceGroupName       = $vault.ResourceGroupName
                    Location                = $vault.Location
                    SkuFamily               = $vault.Sku.Family
                    SkuName                 = $vault.Sku.Name
                    ObjectId                = $policy.ObjectId
                    TenantId                = $policy.TenantId
                    PermissionsToKeys       = $policy.PermissionsToKeys -join ","
                    PermissionsToSecrets    = $policy.PermissionsToSecrets -join ","
                    PermissionsToCertificates = $policy.PermissionsToCertificates -join ","
                    PermissionsToStorage    = $policy.PermissionsToStorage -join ","
                }
            }
        } else {
            # Azure RBAC model: Get role assignments for the Key Vault
            $roleAssignments = Get-AzRoleAssignment -Scope $vault.ResourceId
            foreach ($role in $roleAssignments) {
                [PSCustomObject]@{
                    VaultName               = $vault.VaultName
                    ResourceGroupName       = $vault.ResourceGroupName
                    Location                = $vault.Location
                    SkuFamily               = $vault.Sku.Family
                    SkuName                 = $vault.Sku.Name
                    ObjectId                = $role.PrincipalId
                    TenantId                = $role.TenantId
                    PermissionsToKeys       = "Managed by RBAC"
                    PermissionsToSecrets    = "Managed by RBAC"
                    PermissionsToCertificates = "Managed by RBAC"
                    PermissionsToStorage    = "Managed by RBAC"
                }
            }
        }
    }

    # Export combined Key Vault details and access policies to CSV
    $keyVaultsWithAccessPolicies | Export-Csv -Path $keyVaultsCsvPath -NoTypeInformation -Encoding UTF8

    Write-Host "Key Vaults with access policies exported to $keyVaultsCsvPath"
}

#############################################################################################################

# Get all resources in the subscription
$resources = Get-AzResource

# Filter resources with known Entra directories (Azure AD tenants)
$resourcesWithEntraDirectories = foreach ($resource in $resources) {
    if ( $null -ne $resource.ManagedByTenantId ) {
        [PSCustomObject]@{
            ResourceName       = $resource.Name
            ResourceType       = $resource.Type
            ResourceGroupName  = $resource.ResourceGroupName
            Location           = $resource.Location
            ManagedByTenantId  = $resource.ManagedByTenantId
        }
    }
}

if ($null -eq $resourcesWithEntraDirectories) {
    Write-Host "No resources with known Entra directories found in the subscription."
}

else {
# Define the output CSV file path for resources with known Entra directories
$resourcesWithEntraDirectoriesCsvPath = "resourcesWithEntraDirectories.csv"

# Export resources with known Entra directories to CSV
$resourcesWithEntraDirectories | Export-Csv -Path $resourcesWithEntraDirectoriesCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Resources with known Entra directories exported to $resourcesWithEntraDirectoriesCsvPath"
}
