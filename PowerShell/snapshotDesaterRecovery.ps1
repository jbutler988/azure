# Variables
$sourceSnapshotName = "mySnapshot"
$targetSnapshotName = "mySnapshotCopy"
$resourceGroupName = "myResourceGroup"
$targetRegion = "eastus2"

# Log in and select subscription
Connect-AzAccount
Set-AzContext -SubscriptionId "your-subscription-id"

# Get the source snapshot
$sourceSnapshot = Get-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $sourceSnapshotName

# Create the target snapshot config
$targetSnapshotConfig = New-AzSnapshotConfig `
    -Location $targetRegion `
    -SourceResourceId $sourceSnapshot.Id `
    -CreateOption CopyStart `
    -Incremental

# Start the copy
New-AzSnapshot `
    -Snapshot $targetSnapshotConfig `
    -SnapshotName $targetSnapshotName `
    -ResourceGroupName $resourceGroupName


(Get-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $targetSnapshotName).CompletionPercent