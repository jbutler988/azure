<#
.SYNOPSIS
    This PowerShell script creates a snapshot for a given virtual machine disk and copies the snapshot incrementally to a separate Azure region to provide rudimentary disaster recovery.

.DESCRIPTION
    PowerShell script to create a snapshot of a virtual machine's OS and data disks and copy it to another region.

.NOTES
    Author: Jeremy Butler
    Date: 2025-06-20
    Version: 0.1
#>

# Variables
$targetVmName = "myTargetVM"
$resourceGroupName = "myResourceGroup"
$targetRegion = "eastus2"
$subscriptionId = ""

# Select subscription
Set-AzContext -SubscriptionId $subscriptionId

# Get the target VM and its disks
$targetVm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $targetVmName

# Gather all disk objects (OS + data disks)
$allDisks = @()
$osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $targetVm.StorageProfile.OsDisk.Name
$allDisks += $osDisk

if ($null -eq $targetVm.StorageProfile.DataDisks -or $targetVm.StorageProfile.DataDisks.Count -eq 0) {
    Write-Host "No data disks found for VM $targetVmName."
} else {
    foreach ($dataDisk in $targetVm.StorageProfile.DataDisks) {
        $disk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $dataDisk.Name
        $allDisks += $disk
    }
}

# Create and copy snapshots for each disk
foreach ($disk in $allDisks) {
    $snapshotConfig = New-AzSnapshotConfig `
        -SourceUri $disk.Id `
        -Location $disk.Location `
        -CreateOption Full
    $snapshotConfig = New-AzSnapshotConfig `
        -SourceUri $disk.Id `
        -Location $disk.Location `
        -CreateOption Copy

    $snapshot = New-AzSnapshot `
        -Snapshot $snapshotConfig `
        -SnapshotName $snapshotName `
        -ResourceGroupName $resourceGroupName

    # Validate if disk supports incremental snapshots
    $supportsIncremental = $false
    if ($disk.Sku.Name -eq "Premium_LRS" -or $disk.Sku.Name -eq "StandardSSD_LRS" -or $disk.Sku.Name -eq "Standard_LRS") {
        $supportedRegions = @("eastus", "eastus2", "westus2", "centralus", "northcentralus", "southcentralus", "westeurope", "northeurope", "southeastasia", "australiaeast", "japaneast")
        if ($supportedRegions -contains $targetRegion.ToLower()) {
            $supportsIncremental = $true
        }
    }

    # Create snapshot config for target region (copy)
    if ($supportsIncremental) {
        $targetSnapshotConfig = New-AzSnapshotConfig `
            -Location $targetRegion `
    # Monitor provisioning state
    $provisioningState = (Get-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotCopyName).ProvisioningState
    Write-Host "Snapshot copy provisioning state for ${snapshotCopyName}: ${provisioningState}"
    } else {
        $targetSnapshotConfig = New-AzSnapshotConfig `
            -Location $targetRegion `
            -SourceUri $snapshot.Id `
            -CreateOption CopyStart
        Write-Warning "Incremental snapshots are not supported for disk type $($disk.Sku.Name) in region $targetRegion. Creating a full snapshot copy."
    }

    # Start the copy in the target region
    New-AzSnapshot `
        -Snapshot $targetSnapshotConfig `
        -SnapshotName $snapshotCopyName `
        -ResourceGroupName $resourceGroupName

    # Monitor progress
    $progress = (Get-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotCopyName).CompletionPercent
    Write-Host "Snapshot copy progress for ${snapshotCopyName}: ${progress}%"
}
