Author: Alex
Date: 12/28/2024
Description: This PowerShell script automates user account creation in Microsoft 365 with enhanced security and functionality. It leverages Azure Key Vault to store sensitive configuration values, ensuring they are not exposed within the script itself.

Features
Securely retrieves domain, license SKU ID, and group object IDs from Azure Key Vault.
Generates strong, random passwords for new users.
Requests user confirmation before creating the account.
Handles potential errors during module imports, Key Vault access, Graph connection, user creation, and group membership.
Logs user creation details (username) to a designated log file, excluding sensitive information like passwords.
Allows adding users to multiple groups specified by comma-separated IDs in Key Vault.
Prerequisites
Azure Active Directory (AAD) Tenant: You'll need an AAD tenant with Microsoft 365 services enabled.
Azure Key Vault: Create an Azure Key Vault to store sensitive configuration values.
PowerShell: Ensure you have a recent version of PowerShell installed.
Microsoft Graph Permissions: The script requires permissions to create users and manage groups in Microsoft Graph. You can grant these permissions using Azure AD App Registrations.
Instructions
Configure Azure Key Vault:

Create a Key Vault in your Azure subscription.
Store the following secrets in your Key Vault:
domain: Your Microsoft 365 domain name (e.g., contoso.com).
license-sku-id: The license SKU ID for the users (optional).
group-object-ids: A comma-separated list of group object IDs to add users to (optional).
Grant the script's identity (service account or user account) access to retrieve secrets from Key Vault.
Update Script Configuration:

Replace your-keyvault-name with the name of your Key Vault.
Ensure the script has the appropriate permissions to connect to Microsoft Graph (refer to the Prerequisites section).
Update the $LogFile path if you want to store logs in a different location.
Run the Script:

Open a PowerShell window with elevated privileges (Run as administrator).
Navigate to the directory where the script is saved.
Run the script: ./Automate-UserCreation.ps1 (replace the filename if necessary).
Follow Prompts:

The script will prompt you to enter user information like First Name, Last Name, Department, and Location (optional).
It will then request confirmation before creating the user.
Security Considerations
This script prioritizes security by:

Storing sensitive information (domain, license SKU ID, group object IDs) in Azure Key Vault.
Avoiding logging passwords in plain text.
Using try-catch blocks to handle potential errors gracefully.
Additional Notes
This script is intended for demonstration purposes and may require further customization depending on your specific environment.
Always test the script thoroughly in a non-production environment before deploying it to production.
Consider using Azure AD cmdlets or Microsoft Graph API directly for more granular control over user creation.
Further Resources:

Azure Key Vaults: https://learn.microsoft.com/en-us/azure/key-vault/
Microsoft Graph Permissions: https://learn.microsoft.com/en-us/entra/identity-platform/scopes-oidc
Connect to Microsoft Graph with PowerShell: https://learn.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.01   
