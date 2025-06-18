# Variables
$targetVmName = "myTargetVM"
$sourceSnapshotName = "mySnapshot"
$targetSnapshotName = "mySnapshotCopy"
$resourceGroupName = "myResourceGroup"
$targetRegion = "eastus2"
$subscriptionId = ""

# Log in and select subscription
Connect-AzAccount
Set-AzContext -SubscriptionId $subscriptionId

# Get the target VM and its OS disk
$targetVm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $targetVmName

# Create a snapshot of the target VM's OS disk
$targetVmSnapshotName = "${targetVmName}-osdisk-snapshot"
$osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $targetVm.StorageProfile.OsDisk.Name

$targetVmSnapshotConfig = New-AzSnapshotConfig `
    -SourceUri $osDisk.Id `
    -Location $targetRegion `
    -CreateOption Copy

New-AzSnapshot `
    -Snapshot $targetVmSnapshotConfig `
    -SnapshotName $targetVmSnapshotName `
    -ResourceGroupName $resourceGroupName

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
