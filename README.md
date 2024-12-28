# PowerShell-Collection
My PowerShell Scripts and Code


A curated collection of PowerShell scripts for various automation tasks, system administration, and development utilities.

## Table of Contents

- [Description](#description)
- [Scripts Included](#scripts-included)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

## Description

This repository serves as a central repository for useful PowerShell scripts designed to streamline common tasks and enhance productivity. Whether you're a system administrator, developer, or IT professional, you'll find a range of scripts to automate repetitive processes, manage systems, and perform various development-related operations.

The scripts are organized by category (see [Scripts Included](#scripts-included)) to make it easy to find what you're looking for. Each script includes comments and documentation to explain its functionality and usage.

## Scripts Included

*(This is the most important section. Be specific!)*

*   **System Administration:**
    *   `Get-SystemInfo.ps1`: Gathers comprehensive system information, including OS details, hardware specifications, and installed software.
    *   `Restart-Service.ps1`: Restarts specified Windows services with error handling and logging.
    *   `Check-DiskSpace.ps1`: Monitors disk space usage and alerts if thresholds are met.
*   **Active Directory:** *(If applicable)*
    *   `Get-ADUserReport.ps1`: Generates a report of Active Directory users with specific attributes.
    *   `Set-ADUserPassword.ps1`: Resets passwords for Active Directory users.
*   **Networking:**
    *   `Test-NetworkConnectivity.ps1`: Tests network connectivity to specified hosts or services.
    *   `Get-IPAddress.ps1`: Retrieves the local and public IP address.
*   **Development:**
    *   `Deploy-WebApp.ps1`: Automates the deployment of web applications to IIS.
    *   `Create-DirectoryStructure.ps1`: Creates a predefined directory structure for new projects.
*   **Utilities:**
    *   `Convert-CSVtoHTML.ps1`: Converts CSV files to HTML tables for easy viewing.
    *   `Send-EmailNotification.ps1`: Sends email notifications with customizable content.
*   **Help Desk Automation:**
    *   `HelpDeskAutomation.ps1`: Automates common help desk tasks such as mapping network drives, clearing printer queues remotely, and troubleshooting connectivity. This script aims to provide a single tool for quickly resolving frequent user issues.
        **Key Features:**
        *   **Map Network Drives:** Maps network drives based on user input or predefined configurations. *(You'll want to specify how this works, e.g., by share name, user group, etc.)*
        *   **Clear Printer Queues:** Clears printer queues on specified print servers or client machines. *(Specify how you target the printers, e.g., by printer name, server name, etc.)*
        *   **Troubleshoot Connectivity:** Performs basic network connectivity tests, such as pinging hosts, checking DNS resolution, and testing port connectivity. *(List the specific tests performed, e.g., ping, tracert, Test-NetConnection)*
        **Usage:**
        The script likely accepts parameters to specify which actions to perform and on which targets. Here are some example usage scenarios (replace with your actual parameters):
        *   **Map a network drive:**
            ```powershell
            .\HelpDeskAutomation.ps1 -MapDrive -DriveLetter "Z:" -Share "\\server\share" -Persist
            ```
        *   **Clear a printer queue:**
            ```powershell
            .\HelpDeskAutomation.ps1 -ClearPrinterQueue -PrinterName "Printer01" -Server "PrintServer01"
            ```
        *   **Troubleshoot connectivity to a host:**
            ```powershell
            .\HelpDeskAutomation.ps1 -TestConnectivity -HostName "[invalid URL removed]"
            ```
 
## Contributing

Contributions are welcome! If you have a useful PowerShell script that you'd like to share, please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your contribution: `git checkout -b feature/new-script`
3.  Add your script and update the README with a description.
4.  Commit your changes: `git commit -m "Add new script: <script_name>"`
5.  Push to your branch: `git push origin feature/new-script`
6.  Create a pull request.

## License

*(Add a license. MIT is common for open-source projects. Choose one that suits your needs.)*

This project is licensed under the [MIT License](LICENSE).

## Author

Alex

[LinkedIn Profile] https://www.linkedin.com/in/alejandro-c-a713b9a0/
[Email Address] cor-tech.solutions@outlook.com
