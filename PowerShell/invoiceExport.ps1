# invoiceExport.ps1
# Collects billing invoices for all Azure subscriptions and exports them as CSV files.

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Directory to export invoices
$exportDir = ".\Invoices"
if (-not (Test-Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir | Out-Null
}

foreach ($sub in $subscriptions) {
    Write-Host "Processing subscription: $($sub.Name) [$($sub.Id)]"

    # Set the current subscription context
    Set-AzContext -SubscriptionId $sub.Id | Out-Null

    # Get billing account and profile for the subscription
    $billingAccount = Get-AzBillingAccount | Select-Object -First 1
    if (-not $billingAccount) {
        Write-Warning "No billing account found for subscription $($sub.Name). Skipping."
        continue
    }

    $billingProfile = Get-AzBillingProfile -BillingAccountName $billingAccount.Name | Select-Object -First 1
    if (-not $billingProfile) {
        Write-Warning "No billing profile found for subscription $($sub.Name). Skipping."
        continue
    }

    # Get invoices for the billing profile
    $invoices = Get-AzBillingInvoice -BillingAccountName $billingAccount.Name -BillingProfileName $billingProfile.Name

    if ($invoices) {
        $csvPath = Join-Path $exportDir "$($sub.Name)_$($sub.Id)_Invoices.csv"
        $invoices | Select-Object InvoiceName, InvoicePeriodStartDate, InvoicePeriodEndDate, AmountDue, Status | Export-Csv -Path $csvPath -NoTypeInformation
        Write-Host "Exported invoices to $csvPath"
    } else {
        Write-Host "No invoices found for subscription $($sub.Name)."
    }
}

Write-Host "Invoice export completed."
