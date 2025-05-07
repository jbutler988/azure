######################################################################################
## Warning: This script requires the Az module to be installed and imported.        ##
## Warning: This script requires PowerShell 7.0 or later.                           ##
######################################################################################

# Define the output CSV file path
$outputCsvPath = ".\storageAccountDataUsage.csv"

# Create an array to store the data
$data = [System.Collections.Concurrent.ConcurrentBag[PSCustomObject]]::new()

# Use parallel processing to iterate through subscriptions
$subscriptions | ForEach-Object -Parallel {
    param ($subscription)

    # Set the subscription context
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all storage accounts in the subscription
    $storageAccounts = Get-AzStorageAccount

    foreach ($storageAccount in $storageAccounts) {
        $context = $storageAccount.Context

        # Get all blob containers in the storage account
        $blobContainers = Get-AzStorageContainer -Context $context
        $totalDataUsage = 0

        foreach ($container in $blobContainers) {
            # Get all blobs in the container and calculate total size
            $blobs = Get-AzStorageBlob -Container $container.Name -Context $context -Include Properties
            $totalDataUsage += ($blobs | Measure-Object -Property Length -Sum).Sum
        }

        $totalDataUsageMB = [math]::Round($totalDataUsage / 1MB, 2)

        # Add the data to the concurrent bag
        $data.Add([PSCustomObject]@{
            SubscriptionName   = $subscription.Name
            StorageAccountName = $storageAccount.StorageAccountName
            ResourceGroupName  = $storageAccount.ResourceGroupName
            TotalDataUsageMB   = $totalDataUsageMB
        })
    }
} -ThrottleLimit 12  # Adjust the throttle limit based on your system's resources. This value limits threads being used in parallel processing. Upper limit is your system's CPU core count.

# Export the data to a CSV file
$data | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8
Write-Output "Data exported to $outputCsvPath"
