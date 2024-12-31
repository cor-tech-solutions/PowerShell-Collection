<# 
.SYNOPSIS
    Exports a report of Microsoft 365 users with key attributes like display name, email, licenses and last login date.

.DESCRIPTION
    This script connects to Microsoft Graph, retireves user data, and exports it to a CSV file.
    It supports filetring users based on various criteria and handles portential errors gracefully.

.PARAMETER OutputPath
    The path to the output CSV file.  Defaults to "C:\Reports\M365_User_Report_{yyyyMMdd}.csv".

.PARAMETER Filter
    An OData filter string to filter users (e.g., "startswith(userPrincipalName, 'test')", "AccountEnabled eq true").

.PARAMETER LicensedUserOnly
    A switch parameter to include only users with assigned licenses.

.EXAMPLE
    .\Get-M365UserReport.ps1

.EXAMPLE
    .\Get-M365UserReport.ps1 -OutputPath "D:\Reports\M365Users.csv" -Filter "Department eq 'Sales'"
    
.EXAMPLE
    .\Get-M365UserReport.ps1 -LicensedUsersOnly

.Notes
    Requires the Microsoft.Graph module.  Install it with: Install-Module Microsoft.Graph  
#>

param(
    [Parameter(Mandatory = $false)]
    [string] $OutputPath = "C:\Reports\M365_User_Report_{0:yyyyMMdd}.csv",
    [Parameter(Mandatory = $false)]
    [string] $Filter, # Example: "startswith(userPrincipalName, 'test')" or "accountEnabled eq true"
    [Parameter(Mandatory = $false)]
    [switch] $LicensedUsersOnly # Only include users with licenses
)

try {
    # COnnect to Microsoft Graph with error handling. -ErrorAction Stop will throw an exception if the command fails.
    Write-Verbose "Connecting to Microsoft Graph..."
    Connect-MgGraph -Scopes "User.Read.All" -ErrorAction Stop

    # Retrieve User Data wih filtering
    if ($Filter) {
        Write-Verbose "Applying filter: $Filter"
        $Users = Get-MgUser -Filter $Filter -All -ErrorAction Stop
    } else {
        Write-Verbose "Retrieving all users..."
        $Users = Get-MgUser -All -ErrorAction Stop
    }

    # Filter for licensed users if the switch is provided
    if ($LicensedUsersOnly) {
        Write-Verbose "No users found based on the provided criteria."
        return # Exit the script gracefully
    }

    # Extract Relevant Data. Handle cases where LastPasswordChangeDateTime is null
    Write-Verbose "Extracting user data..."
    $Report = $Users | Select-Object @{Name = "DisplayName"; Expression = { $_.DisplayName } }, UserPrincipalName
                                     @{Name = "LastLogin", Expression = { if ($._LastPasswordChangedDateTime) {$_.LastPasswordChangeDateTime.ToLocalTime() } else { "N/A" } } }, # Convert to local time
                                     @{Name = "Licenses"; Expression = { ($_.AssignedLicenses | ForEach-Object {$_.SkuId}) -join ";" } }, # Show licenses as a semicolon separated list
                                     MailEnabled,
                                     AccountEnabled,
                                     UserType

    # Create directory if it doesn't exist
    $Directory = Split-Path -Path $OutputPath
    of (!(Test-Path -Path $Directory)) {
        Write-Verbose "Creating directory: $Directory"
        New-Item -ItemType Directory -Path $Directory | Out-Null
    }

    # Export to CSV with error handling and UTF8 encoding
    Write-Verbose "Exporting report to: $OutputPath"
    $Report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 -ErrorAction Stop

    Write-Host "Report Generated: $OutputPath"
} catch {
    # Handle any errors that occur
    Write-Error "An error occurred: $($_.Exception.Message)"
    if ($_.Exception.InnerException) {
        Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
    } 
    exit 1 # Exit with a non-zero code to indicate failure
}
finally {
    # Disconnect from Microsoft Graph (optinal but recommended)
    Write-Verbose "Disconnecting from Microsoft Graph..."
    Disconnect-MgGraph
}