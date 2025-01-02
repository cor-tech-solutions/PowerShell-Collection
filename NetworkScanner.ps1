# Script: Network Scanner
# Description: Scans a specified subnet for active hosts using ping and attempts to
# Author: Alex Cortez
# Date: January 1, 2025

# Configuration:
# Set the subnet to scan (e.g., "192.168.1"). This is the first three octects.
$Subnet = "192.168.1"
# Set the starting IP address for the last octect.
$StartIP = 1
# Set the ending IP address for the last octect.
$EndIP = 254

# Set the number of threads for paralle scanning. Adjust based on system resourcess
# Higher values can improve speed but consume more resources.
$Threads = 10

# Create an array to store the scan results.
$Results = @()

# Function: Test-IP
# Description: Tests the availability of a single IP address using ping and attempts to resolve the hostname and MAC address.
function Test-IP {
    param (
        [string]$IP # The IP address to test.
    )

    try {
        # Use Test-Connection (ping) with a timeout and suppress output.
        $Ping = Test-Connection -ComputerName $IP -Count 1 -Quiet -ErrorAction SilentlyContinue

        if ($Ping) {
            # Host is online. Attempt to resolve the hostname.
            try {
                $HostName = [System.Net.Dns]::GetHostEntry($IP).HostName 
            }
            catch {
                Write-Warning "Error resolving hostname for $IP: $($_.Exception.Message)"
                $HostName = "N/A"
            }

            # Attempt to get the MAC address using arp. This required admin privileges and might not work across subnets.
            try {
                $arp = arp -a $IP | Select-String -Pattern "physical" # Get the arp table entry for the IP.
                if ($arp) {
                    $MAC = ($arp -split " ")[2] # Extract the MAC address from the arp output.
                } else {
                    $MAC = "N/A" # MAC address not found.
                }
            }
            catch {
                Write-Warning "Error getting MAC address for $IP: $($_.Exception.Message)"
                $MAC = "N/A" # Error getting MAC address.
            }

            # Create a custom object to store the results for this IP.
            [PSCustomObject]@{
                IPAddress = $IP
                Status = "Online"
                HostName = $HostName
                MACAddress = $MAC
            }
        }
        else {
            # Host if offline.
            [PSCustomObject]@{
                IPAddress = $IP
                Status = "Error"
                HostName = "N/A"
                MACAddress = "N/A"
            }
        } 
    }
    catch {
        Write-Warning "Error testing IP $IP: $($_.Exception.Message)"
        [PSCustomObject]@{
            IPAddress = $IP
            Status = "Error"
            HostName = "N/A"
            MACAddress = "N/A"
        }
    }
}


# Create a runspace pool for parallel execution.
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, $Threads)
$RunspacePool.Open()

# Create jobs for each IP address.
$Jobs = foreach ($i in $StartIP..$EndIP) {
    $IP = "$Subnet.$i" # Construct the full IP address.
    $Runspace = [System.Management.Automation.PowerShell]::Create() # Create a new PowerShell instance for the job.
    $Runspace.RunspacePool = $RunspacePool # Assign the runspace pool.
    $Runspace.AddScript({ Test-IP -IP $args[0] }) | Out-Null # Add the scriptblock to execute the Test-IP function.
    $Runspace.AddParameter("args[0]", $IP) | Out-Null # Add the IP address as a parameter to the scriptbook.
    [PSCustomObject]@{
        Runspace = $Runspace # Store the runspace.
        Result = $Runspace.BeginInvoke() # Start  the asynchronous execution.
    }
}

# Wait for all jobs to complete and collec the results.
foreach ($Job in $Jobs) {
    $Results += $Job.Runspace.EndInvoke($Job.Result) # Get the result from the asynchronous operation.
    $Job.Runspace.Dispose() # Dispose of the runspace to release resources.
}

# Close and dispose of the runspace pool.
$RunspacePool.Close()
$RunspacePool.Dispose()

# Output the results in a table format.
$Results | Format-Table -AutoSize

# Optional: Export the results to a CSV file.
$Results | Export-Csv -Path "NetworkScanResults.csv" -NoTypeInformation

# Displau a completion message.
Write-Host "Scan Complete. Results saved to NetworkScanResults.csv"