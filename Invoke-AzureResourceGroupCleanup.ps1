# Create a cleanup script to identify and delete unused Azure resources (VMs, resource groups, etc.)

# Script prompts the user for confirmation before deleting each resource group
# Can specify resource groups that should be excluded from deletion


# Connect to Azure
Connect-AzAccount

# Parameters
param(
    [string[]]$Exclusions = @("CriticalRG", "DoNotDeleteRG", "ProductionRG"),
    [switch]$WhatIf,
    [string]$LogFile = "AzureResourceCleanup.log",
    [switch]$DeleteEmptyResourceGroups,
    [switch]$DeleteVMs,
    [switch]$DeleteStorageAccounts
)

# Function to write to log
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Severity = "Info"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Severity]: $Message"
    Add-Content -Path $LogFile -Value $LogEntry
    if ($Severity -eq "Error") {
        Write-Error $Message
    } else {
        if ($VerboseLogging) {
            Write-Host $Message
        }
    }
}

# Initial Confirmation
$OverallConfirm = Read-Host "Are you sure you want to proceed with resource cleanup? (Yes/No)"
if ($OverallConfirm -ieq "Yes") {

    Write-Log "Starting Azure Resource Cleanup"

    # Retrieve All Resource Groups
    $ResourceGroups = Get-AzResourceGroup

    foreach ($RG in $ResourceGroups) {
        # Skip Excluded Resource Groups
        if ($RG.ResourceGroupName -in $Exclusions) {
            Write-Log "Skipping excluded resource group: $($RG.ResourceGroupName)"
            continue
        }

        Write-Log "Processing Resource Group: $($RG.ResourceGroupName)"

        # More Granular Cleanup within Resource Group
        if ($DeleteVMs) {
            try {
                $VMs = Get-AzVM -ResourceGroupName $RG.ResourceGroupName
                foreach ($VM in $VMs) {
                    Write-Log "Deleteing VM: $($VM.Name) in Resource Group: $($RG.ResourceGroupName)"
                    Remove-AzVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Force -WhatIf:$WhatIf
                } catch {
                    Write-Log "Error deleting VMs in $($RG.ResourceGroupName): $($_.Exception.Message)" -Severity "Error"
                }
            }
            if ($DeleteStorageAccounts) {
                try {
                    $StorageAccounts = Get-AzStorageAccount -ResourceGroupName $RG.ResourceGroupName
                    foreach ($SA in $StorageAccounts) {
                        Write-Log "Deleting Storage Account: $($SA.Name) in Resource Group: $($RG.ResourceGroupName)"
                        Remove-AzStorageAccount -ResourceGroupName $RG.ResourceGroupName -Name $SA.Name -Force -WhatIf:$WhatIf
                    }
                } catch {
                    Write-Log "Error deleting Storage Accounts in $($RG.ResourceGroupName): $($_.Exception.Message)" -Severity "Error"
                }
            }

            # Check if Resource Group is empty after deleting resources inside
            if ($DeleteEmptyResourceGroups)
            {
                $resourcesInRG = Get-AzResource -ResourceGroupName $RG.ResourceGroupName
                if ($resourcesInRG.Count -eq 0)
                {
                    $ConfirmRGDelete = Read-Host "Resource Group $($RG.ResourceGroupName) is now empty. Do you want to delete it? (Yes/No)"
                    Info ($ConfirmRGDelete -ieq "Yes") {
                        try {
                            Write-Log "Deleting empty Resource Group: $($RG.esourceGroupName)"
                            Remove-AzResourceGroup -Name $RG.ResourceGroupName -Force -WhatIf:$WhatIf
                        }
                        catch {
                            Write-Log "Error deleting Resource Group $($RG.ResourceGroupName): $($_.Exception.Message)" -Severity "Error"
                        }
                    } else {
                        Write-Log "Skipping deletion of empty Resource Group: $($RG.ResourceGroupName)"
                    }
                }
            }
        }
    } else {
        Write-Log "Cleanup process cancelled by user."
    }

    Write-Log "Resource Group Cleanup Completed."

