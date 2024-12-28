Author: Alex
Date: 12/25/2024
Description: This PowerShell script automates common help desk tasks, streamlining workflows and improving efficiency. It provides an interactive menu for users to:

Map network drives: Easily map network shares to drive letters for users.
Clear printer queues remotely: Troubleshoot printing issues by clearing print queues on remote computers.
Troubleshoot connectivity: Ping a hostname or IP address and perform DNS resolution to diagnose network connectivity problems.
Features:

Interactive Menu: Users can choose the desired task from a simple menu.
Error Handling: The script includes error handling to provide informative messages for invalid input or failed actions.
User Input: The script prompts users for necessary information when performing tasks.
Requirements:

PowerShell 5.1 or later
How to Use:

Save the script: Save the script as HelpDeskAutomation.ps1.
Run the script: Open a PowerShell window and navigate to the directory where you saved the script. Then, run the following command:
PowerShell

.\HelpDeskAutomation.ps1
Follow the menu: Select the desired task from the menu by entering the corresponding number (1-4).
Provide information (when prompted): Enter the necessary information for the chosen task (e.g., drive letter, network path, computer name, etc.).
The script will execute the selected task and provide feedback on the results.

Examples:

Mapping a network drive:

Choose option "1" from the menu.
When prompted, enter the desired drive letter (e.g., Z).
Enter the network path to the shared folder (e.g., \server\share).
Optionally, choose "y" if you want the drive to persist across logins, or "n" for a temporary mapping.
Clearing a printer queue:

Choose option "2" from the menu.
Enter the name of the remote computer where the printer is installed.
Enter the name of the printer you want to clear the queue for.
Troubleshooting connectivity:

Choose option "3" from the menu.
Enter the hostname or IP address of the device you want to troubleshoot.
Additional Notes:

You may need to adjust permissions on remote computers for the script to clear printer queues successfully.
For advanced customization, you can modify the functions within the script.
Disclaimer: This script is provided for informational purposes only. The author is not responsible for any damages or unintended consequences arising from its use.
