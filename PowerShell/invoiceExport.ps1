<#
.SYNOPSIS
    This PowerShell script creates a .csv file with invoicing information for all available subscriptions to the user.

.DESCRIPTION
    This PowerShell script creates a .csv file with invoicing information for all available subscriptions to the user.

.NOTES
    Author: Jeremy Butler
    Date: 2025-06-20
    Version: 0.1
#>

# Collects billing invoices for all Azure subscriptions and exports them as CSV files.

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Retrieve billing accounts once (assuming shared across subscriptions)
$billingAccounts = Get-AzBillingAccount

# Directory to export invoices
$exportDir = ".\Invoices"
if (-not (Test-Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir | Out-Null
}

# Track export results
$exportSummary = @()

foreach ($sub in $subscriptions) {
    Write-Host "Processing subscription: $($sub.Name) [$($sub.Id)]"

    # Set the current subscription context
    Set-AzContext -SubscriptionId $sub.Id | Out-Null

    # Get billing account and profile for the subscription
    $billingAccount = $billingAccounts | Select-Object -First 1
    if (-not $billingAccount) {
        Write-Warning "No billing account found for subscription $($sub.Name). Skipping."
        $billingAccount = Get-AzBillingAccount | Select-Object -First 1
        if (-not $billingAccount) {
            Write-Warning "No billing account found for subscription $($sub.Name). Skipping."
            $exportSummary += [PSCustomObject]@{ Subscription = $sub.Name; Exported = 0; Status = "No billing account" }
            continue
        }
    }

    # Get all billing profiles for the billing account
    $billingProfiles = Get-AzBillingProfile -BillingAccountName $billingAccount.Name

    # Attempt to find the billing profile associated with the current subscription
    $billingProfile = $billingProfiles | Where-Object { $_.InvoiceSections -and ($_.InvoiceSections.SubscriptionId -contains $sub.Id) } | Select-Object -First 1

    if (-not $billingProfile) {
        Write-Warning "No billing profile found for subscription $($sub.Name). Skipping."
        $exportSummary += [PSCustomObject]@{ Subscription = $sub.Name; Exported = 0; Status = "No billing profile" }
        continue
    }

    # Get invoices for the billing profile
    $invoices = Get-AzInvoice -BillingAccountName $billingAccount.Name -BillingProfileName $billingProfile.Name

    if ($invoices) {
        # Sanitize subscription name for file path
        $sanitizedSubName = ($sub.Name -replace '[\\\/:\*\?"<>\|]', '_')
        $csvPath = Join-Path $exportDir "$sanitizedSubName_$($sub.Id)_Invoices.csv"
        $invoices | Select-Object InvoiceName, InvoicePeriodStartDate, InvoicePeriodEndDate, AmountDue, Status | Export-Csv -Path $csvPath -NoTypeInformation
        Write-Host "Exported invoices to $csvPath"
        $exportSummary += [PSCustomObject]@{ Subscription = $sub.Name; Exported = $invoices.Count; Status = "Exported" }
    }
    else {
        Write-Host "No invoices found for subscription $($sub.Name)."
        $exportSummary += [PSCustomObject]@{ Subscription = $sub.Name; Exported = 0; Status = "No invoices" }
    }
}
Write-Host "Invoice export completed."
Write-Host ""
Write-Host "Export Summary:"
$exportSummary | Format-Table -AutoSize
Write-Host "Invoice export completed."
