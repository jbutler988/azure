# Specify the subscription ID
$subscriptionId = "<Your-Subscription-ID>"

# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Get all role assignments for the subscription
$roleAssignments = Get-AzRoleAssignment -all -includeinherited -Scope "/subscriptions/$subscriptionId"

# Define the output CSV file path
$outputCsvPath = "roleAssignments.csv"

# Export role assignments to CSV
$roleAssignments | Select-Object `
    DisplayName, `
    RoleDefinitionName, `
    PrincipalType, `
    Scope, `
    Id `
    | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Role assignments exported to $outputCsvPath"

#############################################################################################################

# Get all custom roles for the subscription
$customRoles = Get-AzRoleDefinition | Where-Object { $_.IsCustom -eq $true }

# Define the output CSV file path for custom roles
$customRolesCsvPath = "customRoles.csv"

# Export custom roles to CSV
$customRoles | Select-Object `
    Name, `
    Description, `
    Actions, `
    NotActions, `
    AssignableScopes `
    | Export-Csv -Path $customRolesCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Custom roles exported to $customRolesCsvPath"

#############################################################################################################

# Get all role assignments for managed identities
$managedIdentityRoleAssignments = $roleAssignments | Where-Object { $_.PrincipalType -eq "ServicePrincipal" -and $_.DisplayName -like "msi*" }

# Define the output CSV file path for managed identity role assignments
$managedIdentityCsvPath = "managedIdentityRoleAssignments.csv"

# Export managed identity role assignments to CSV
$managedIdentityRoleAssignments | Select-Object `
    DisplayName, `
    RoleDefinitionName, `
    PrincipalType, `
    Scope, `
    Id `
    | Export-Csv -Path $managedIdentityCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Managed identity role assignments exported to $managedIdentityCsvPath"

#############################################################################################################

# Get all Key Vaults in the subscription
$keyVaults = Get-AzKeyVault -SubscriptionId $subscriptionId

# Define the output CSV file path for Key Vaults
$keyVaultsCsvPath = "keyVaults.csv"

# Export Key Vault details to CSV
$keyVaults | Select-Object `
    VaultName, `
    ResourceGroupName, `
    Location, `
    Sku.Family, `
    Sku.Name `
    | Export-Csv -Path $keyVaultsCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Key Vaults exported to $keyVaultsCsvPath"

# Get Key Vault access policies
$keyVaultAccessPolicies = foreach ($vault in $keyVaults) {
    Get-AzKeyVaultAccessPolicy -VaultName $vault.VaultName | Select-Object `
        VaultName, `
        ObjectId, `
        PermissionsToKeys, `
        PermissionsToSecrets, `
        PermissionsToCertificates, `
        PermissionsToStorage
}

# Define the output CSV file path for Key Vault access policies
$keyVaultAccessPoliciesCsvPath = "keyVaultAccessPolicies.csv"

# Export Key Vault access policies to CSV
$keyVaultAccessPolicies | Export-Csv -Path $keyVaultAccessPoliciesCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Key Vault access policies exported to $keyVaultAccessPoliciesCsvPath"

#############################################################################################################

# Get all resources in the subscription
$resources = Get-AzResource -SubscriptionId $subscriptionId

# Filter resources with known Entra directories (Azure AD tenants)
$resourcesWithEntraDirectories = foreach ($resource in $resources) {
    if ($resource.ManagedByTenantId -ne $null) {
        [PSCustomObject]@{
            ResourceName       = $resource.Name
            ResourceType       = $resource.Type
            ResourceGroupName  = $resource.ResourceGroupName
            Location           = $resource.Location
            ManagedByTenantId  = $resource.ManagedByTenantId
        }
    }
}

# Define the output CSV file path for resources with known Entra directories
$resourcesWithEntraDirectoriesCsvPath = "resourcesWithEntraDirectories.csv"

# Export resources with known Entra directories to CSV
$resourcesWithEntraDirectories | Export-Csv -Path $resourcesWithEntraDirectoriesCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Resources with known Entra directories exported to $resourcesWithEntraDirectoriesCsvPath"
