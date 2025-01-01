Author: Alex
Date: 12/31/2024
Description: This PowerShell script helps you identify and delete unused resources (VMs, Storage Accounts, etc.) within Azure Resource Groups. It provides flexibility with exclusions, confirmation prompts, and logging.

## Features:
Identify and delete unused VMs and Storage Accounts within resource groups.
Specify resource groups to be excluded from cleanup.
Prompt for confirmation before deleting each resource group and empty resource groups.
Log cleanup activities to a file.
Optionally control logging verbosity (implicit based on execution context).

## Using the Script:
Save the script: Download or copy the script content and save it as a .ps1 file (e.g., Cleanup-AzureResourceGroups.ps1).
Set Execution Policy (if needed): Depending on your PowerShell execution policy, you might need to run Set-ExecutionPolicy RemoteSigned to allow running downloaded scripts.
Run the script: Open a PowerShell window and navigate to the directory where you saved the script. Then, run the script with desired parameters:
PowerShell

.\Cleanup-AzureResourceGroups.ps1 -DeleteVMs -DeleteStorageAccounts -DeleteEmptyResourceGroups -LogFile "CleanupLog.txt"

## Parameters:
-Exclusions (string[]): An array of resource group names to exclude from cleanup (default: "CriticalRG", "DoNotDeleteRG", "ProductionRG").
-WhatIf (switch): Performs a dry run without deleting anything (useful for testing).
-LogFile (string): Path to the log file for recording cleanup activities (default: "AzureResourceCleanup.log").
-DeleteVMs (switch): Enables deletion of VMs within resource groups.
-DeleteStorageAccounts (switch): Enables deletion of Storage Accounts within resource groups.
-DeleteEmptyResourceGroups (switch): Prompts for deleting resource groups that become empty after cleanup.

## Notes:
This script requires Azure PowerShell cmdlets. Ensure you have them installed before running the script.
Be cautious when deleting resources as it's a permanent action.
Review the script's code and comments for a deeper understanding.

## Contributing:
Feel free to suggest improvements or additional features by creating a pull request on a public repository hosting the script.
