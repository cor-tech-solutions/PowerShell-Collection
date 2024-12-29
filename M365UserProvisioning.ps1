# Automate user account creation in Microsoft 365 - Enhance Security and Features
# Uses Azure Key Vault for secure configuration

# Region Configuration and Setup

# Import necessary modules
try {
    Import-Module Az.KeyVault
    Import-Module Microsoft.Graph
} catch {
    Write-Error "Failed to import required modules: $($_.Exception.Message)"
    Exit 1
}

# Azure Key Vault Configuration (Replace with your values)
$KeyVaultName = "your-keyvault-name"
$DomainSecretName = "domain"
$LicenseSkuIdSecretName = "License-sku-id"
$GroupObjectIdsSecretName = "group-object-ids"

# Log File Path
$LogFile = "C:\UserCreation.log"

# Function to write to log
Function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")][string]$Severity = "Info"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "Timestamp [$Severity] $Message"
    Add-Content -Path $LogFile -Value $LogEntry
    if ($Severity -eq "Error") { Write-Error $Message } # Also write to console for errors
    else { Write-Host $Message}
}

# Retrieve secrets from Azure Key Vault
Function Get-SecretFromKeyVault {
    param(
        [string]$SecretName
    ) try {
        $secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName
        return $secret.SecretValueText
    } catch {
        Write-Log "Error retrieving '$SecretName' from Key Vault: $($_.Exception.Message)" -Severity "Error"
        return $null # Return null to indicate failure
    }
}

# Retrieve configuration from Key Vault
$Domain = Get-SecretFromKeyVault -SecretName $DomainSecretName
$DefaultLicenseSkuId = Get-SecretFromKeyVault -SecretName $LicenseSkuIdSecretName
$GroupObjectIdsString = Get-SecretFromKeyVault -SecretName $GroupObjectIdsSecretName

# Convert the string of comma separated value to an array of object IDs
if ($GroupObjectIdsString) {
    $DefaultGroups = $GroupObjectIdsString -split ","
} else {
    Write-Log "Failed to retrieve required configuration from Key Vault. Exiting"
    Exit 1
}

# endregion

# Region User Input and Validation

# User Input
$FirstName = Read-Host "Enter First Name"
$LastName = Read-Host "Enter Last Name"
$Department = Read-Host "Enter Department (Optional)"
$Location = Read-Host "Enter Location (Optional)"
$UserEmail = "FirstName.$LastName@domain.com"

# Configrm user details
Write-Host "Please confirm the information."
Write-Host "First Name: $FirstName"
Write-Host "Last Name: $LastName"
Write-Host "Email: $UserEmail"
Write-Host "Department: $Department"
Write-Host "Location: $Location"

$confirmation = Read-Host "Are these details correct? (y/n)"
if ($confirmation -ne "y") {
    Write-Log "User creation canceled by user."
    Write-Host "User creation canceled."
    Exit 0
}

# endregion

# Region USer Creation and Group Membership

# Generate a strong random password
Function Generate-StrongPassword {
    [System.Web.Security.Membership]::GeneratePassword(16, 2) # Length 16, 2 non-alphanumeric
}
$Password = Generate-StrongPassword

# Connect to Microsoft Graph with error handling
Write-Log "Connecting to Microsoft Graph..."
try {
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.Read.All"
    Write-Log "Connected to Microsoft Graph."
}
catch {
    Write-Log "Error connecting to Microsoft Graph: $($_.Exception.Message)" -Severity "Error"
    Exit 1
}


# Create User
Write-Log "Creating user: $UserEmail" # Log the username
try {
    $user = New-MgUser -AccountEnabled $true `
    -DisplayName "$FirstName $LastName" `
    -UserPrincipalName $UserEmail `
    -PasswordProfile @{ Password = $Password; ForceChangePasswordNextSignIn = $true } `
    -MailNickName "$FirstName$LastName"

    Write-Host "User $UserEmail created successfully"
    Write-Log "User created successfully: $UserEmail"

        # Add User to Groups
    if ($DefaultGroups) {
        foreach ($GroupdId in $DefaultGroups) {
            try {
                Add-MgGroupMember -GroupdId $GroupdId -DirectoryObjectId $user.Id
                Write-Log "User $UserEmail added to group: $GrouId"
            } catch {
                Write-Log "Error adding user $UserEmail to grpup $GroupdId: $($_.Exception.Message)" -Severity "Warning" # Warning as group membership shouldn't halt user creation
            }
        }
    }
} catch {
    Write-Log "Error creating user $UserEmail: $($_.Exception.Message)" -Severity "Error"
}

# endregion

