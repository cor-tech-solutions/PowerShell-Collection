Author: Alex Cortez
Date: 1/2/2025
Description: This script scans a specified subnet for active hosts using ping and attempts to resolve hostnames and MAC addresses.

Features:

Scans a subnet of IP addresses.
Uses ping to determine if a host is online.
Attempts to resolve hostnames for online hosts.
Attempts to retrieve MAC addresses for online hosts (requires administrative privileges).
Outputs results in a table format.
Optionally exports results to a CSV file.
Requirements:

PowerShell 5.1 or later
Administrative privileges (for retrieving MAC addresses)
How to Use:

Edit the Configuration Section:

Update the $Subnet variable with the subnet you want to scan (e.g., "192.168.1").
Adjust the $StartIP and $EndIP variables to define the IP address range to scan within the subnet.
Modify the $Threads variable to adjust the number of parallel threads used for scanning (higher values can improve speed but consume more resources).
Run the Script:

Save the script as a .ps1 file (e.g., NetworkScanner.ps1).

Open a PowerShell window with administrator privileges (if you want to retrieve MAC addresses).

Navigate to the directory where you saved the script.

Run the script using the following command:

PowerShell

.\NetworkScanner.ps1
Output:

The script will display the scan results in a table format, including:

IP Address
Status (Online/Offline/Error)
Hostname (if resolvable)
MAC Address (if retrieved and accessible)
Optionally, the script can export the results to a CSV file named "NetworkScanResults.csv".

Security Disclaimer:

Retrieving MAC addresses using arp requires administrative privileges. Running this script without administrator privileges will result in MAC addresses not being retrieved. Additionally, arp is typically limited to the local subnet. Scanning across different subnets will likely not resolve MAC addresses.
