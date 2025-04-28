# Define the path to the JSON file
$jsonFilePath = "roles.json"

# Load the JSON file
if (-Not (Test-Path -Path $jsonFilePath)) {
    Write-Error "JSON file not found at path: $jsonFilePath"
    exit
}

$rolesData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Set the subscription ID
$subscriptionId = "<Your-Subscription-ID>"
Set-AzContext -SubscriptionId $subscriptionId

# Iterate through the roles in the JSON file and assign them
foreach ($role in $rolesData) {
    $principalId = $role.principalId
    $roleDefinitionName = $role.roleDefinitionName
    $scope = $role.scope

    Write-Host "Assigning role '$roleDefinitionName' to principal '$principalId' at scope '$scope'..."

    New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName $roleDefinitionName -Scope $scope -ErrorAction Stop
    Write-Host "Role assignment successful."
}

Write-Host "All role assignments completed successfully."
