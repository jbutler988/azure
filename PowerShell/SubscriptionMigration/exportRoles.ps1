# This script exports all role assignments for a specific Azure subscription
# and saves them to a JSON file. The exported data can later be used to import
# the role assignments into a new subscription after migration.

# Define variables
$subscriptionId = "e6f064c5-ca13-4772-8729-d11921b1b800"
$outputFile = "RoleAssignmentsExport.json"

# Set the subscription context
Write-Host "Setting subscription context to $subscriptionId..."
Set-AzContext -SubscriptionId $subscriptionId

# Get all role assignments for the subscription
Write-Host "Fetching role assignments for subscription $subscriptionId..."
$roleAssignments = Get-AzRoleAssignment

# Export role assignments to a JSON file
Write-Host "Exporting role assignments to $outputFile..."
$roleAssignments | ConvertTo-Json -Depth 10 | Set-Content -Path $outputFile

Write-Host "Role assignments have been exported successfully to $outputFile."
