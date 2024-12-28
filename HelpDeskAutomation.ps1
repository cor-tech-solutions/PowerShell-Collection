# Help Desk Automation Script
# Author: Alex
# Date: 12/25/2024
# Description: Automates common help desk tasks such as mapping network drives, clearing printer queues remotely, and troubleshooting connectivity.


# How it works
# 1. Maping Network Drives - Users input the drive letter and network path, and the script uses New-PSDrive to map the drive
# 2. Clearing Printer Queues - The script queries the Win32_PRintJob class to find and delet the print jobs for the specified printer on the specified computer
# 3. Troubleshooting Connectivity - The script pings the hostname and resolves its DNS name using Test-Connection and Resolve-DnsName
# 4. Interactive Menu - The script uses a simple menu to guide the uset through the different options

# Function tp map a network drive
function Map-NetworkDrive {
    param (
        [string]$DriveLetter,
        [string]$NetworkPath,
        [switch]$Persist 
    )
    try {
        if ($DriveLetter.Length -ne 1 -or $DriveLetter -notmatch "^[A-Z]$") {
            throw "Invalid drive letter. Must be a single uppercase letter (A-Z)."
        }
        if ($NetworkPath -notmatch "^\\\\") {
            throw "Invalid network path. Must start with \\\\."
        }

        Write-Host "Mapping drive $DriveLetter to $NetworkPath..."
        if ($Persist) {
            New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root $NetworkPath -Persist
        } else {
            New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root $NetworkPath
        }
        Write-Host "Drive $DriveLetter successfully mapped to $NetworkPath." -ForegroundColor Green  
    } catch {
        Write-Error "Failed to map drive $DriveLetter : $_"
    }
}

# Function to clear printer queues remotely
function Clear-PrinterQueue {
    param (
        [string]$ComputerName,
        [string]$PrinterName
    )
    try {
        Test-Connection -ComputerName $ComputerName -Quiet -ErrorAction Stop
        Write-Host "Clearing printer queue for $PrinterName on $ComputerName..."
        $wmiQuery = "SELECT * FROM Win32_PrintJob WHERE Name LIKE '%$PrinterName%'"
        $printJobs = Get-WmiObject -Query $wmiQuery -ComputerName $ComputerName
        $jobsDeleted = $printJobs.Count
        foreach ($job in $printJobs) {
            $job.Delete()
        }
        Write-Host "Cleared $jobsDeleted print job(s) successfully for $PrinterName on $ComputerName." -ForegroundColor Green
    } catch {
        Write-Error "Failed to clear printer queue: $_"
    }
}

# Function to troubleshoot connectivity
function Troubleshoot-Connectivity {
    param (
        [string]$Hostname
    )
    try {
        if ($Hostname -notmatch "^([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}|^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
            throw "Invalid hostname or IP address."
        }
        Write-Host "Pinging $Hostname..."
        $pingResult = Test-Connection -ComputerName $Hostname -Count 1 -Quiet
        if ($pingResult) {
            Write-Host "$Hostname is reachable." -ForegroundColor Green
        } else {
            Write-Host "$Hostname is not reachable." -ForegroundColor Red
        }

        Write-Host "Resolving DNS for $Hostname..."
        $dnsResult = Resolve-DnsName -Name $Hostname -ErrorAction Stop
        Write-Host "DNS resolved for $Hostname: $($dnsResult.IPAddress)" -ForegroundColor Green
    } catch {
        Write-Error "Connectivity troubleshooting failed for $Hostname: $_"
    }
}

# Main Menu
function Main-Menu {
    while ($true) {
        Write-Host "`n--- Help Desk Automation ---"
        Write-Host "1. Map a Network Drive"
        Write-Host "2. Clear Printer Queue"
        Write-Host "3. Troubleshoot Connectivity"
        Write-Host "4. Exit"
        $choice = Read-Host "Enter your choice (1-4)"

        switch ($choice) {
            "1" { # Map Network Drive
                $driveLetter = Read-Host "Enter the drive letter (e.g., Z)"
                $NetworkPath = Read-Host "Enter the network path (e.g., \\server\share)"
                $persistChoice = Read-Host "Make the drive persistent across logins? (y/n)"
                if ($persistChoice -eq "y") {
                    Map-NetworkDrive -DriveLetter $driveLetter -NetworkPath $NetworkPath -Persist
                } else {
                    Map-NetworkDrive -DriveLetter $driveLetter -NetworkPath $NetworkPath
                }
            }
            "2" { # Clear Printer Queue
                $computerName = Read-Host "Enter the remote computer name"
                $printerName = Read-Host "Enter the printer name"
                Clear-PrinterQueue -ComputerName $computerName -PrinterName $printerName
            }
            "3" { # Troubleshoot Connectivity
                $hostname = Read-Host "Enter the hostname or IP address to troubleshoot"
                Troubleshoot-Connectivity -Hostname $hostname
            }
            "4" { # Exit
                Write-Host "Exiting... Goodbye!" -ForegroundColor Yellow
                break
            }
            default {
                Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            }
        }
    }
}

# Start the script
Main-Menu
