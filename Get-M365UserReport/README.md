Author: Alex
Date: 12/25/2024
Description: This PowerShell script automates the generation of a report containing key attributes for Microsoft 365 users.

Functionality
Connects to Microsoft Graph using the Microsoft.Graph module.
Retrieves user data based on optional filtering criteria.
Extracts relevant user information like display name, email, licenses, and last login date.
Exports the user data to a CSV file.
Usage
Save the script: Save this code as Get-M365UserReport.ps1.
Install the Microsoft.Graph module: If not already installed, run Install-Module Microsoft.Graph in your PowerShell session.
Run the script: Execute the script using .\Get-M365UserReport.ps1 in your PowerShell terminal.
Optional Parameters:

-OutputPath: Specify the output path for the CSV file. Defaults to C:\Reports\M365_User_Report_{yyyyMMdd}.csv.
-Filter: Apply an OData filter to the user data retrieval. Use syntax like startswith(userPrincipalName, 'test') or accountEnabled eq true.
-LicensedUsersOnly: Include only users with assigned licenses in the report.
Examples:

Generate a report for all users with the default output path:
PowerShell

.\Get-M365UserReport.ps1
Generate a report for users in the "Sales" department and save it to a specific path:
PowerShell

.\Get-M365UserReport.ps1 -OutputPath "D:\Reports\SalesUsers.csv" -Filter "Department eq 'Sales'"
Generate a report including only users with assigned licenses:
PowerShell

.\Get-M365UserReport.ps1 -LicensedUsersOnly
Notes
This script requires the Microsoft.Graph module. Install it with Install-Module Microsoft.Graph.
Ensure you have the necessary permissions to access user data in Microsoft Graph.
Contributing
Feel free to suggest improvements or additional features by creating a pull request on a forked copy of this repository (if applicable).
