Author: Alex Cortez
Date: 1/2/2025
Description: This script provides a basic calculator for performing arithmetic operations.

Important Note: This calculator currently evaluates expressions from left to right and does not respect the order of operations (PEMDAS/BODMAS). For example, 2 + 3 * 4 will be evaluated as (2 + 3) * 4 instead of 2 + (3 * 4).

Features:
Performs basic arithmetic operations (+, -, *, /) on numbers (including decimals and negative numbers).
Validates user input to ensure it's in the correct format (number operator number).
Handles errors like division by zero and invalid input.

How to Use:
Save the script as a .ps1 file (e.g., calculator.ps1).
Open PowerShell.
Navigate to the directory where you saved the file using the cd command.
Run the script using ./calculator.ps1.
Enter an expression (e.g., 2 + 3, 10 * 5, 8 / 2, 7 - 4).
Type "exit" to quit the calculator.

Example:
PowerShell

Enter an expression (e.g., 2 + 3, 10 * 5, 8 / 2, 7 - 4, or 'exit'): 2 + 3
Result: 5

Enter an expression (e.g., 2 + 3, 10 * 5, 8 / 2, 7 - 4, or 'exit'): 8 / 2
Result: 4

Enter an expression (e.g., 2 + 3, 10 * 5, 8 / 2, 7 - 4, or 'exit'): exit
Exiting calculator.

Requirements:
PowerShell 5.1 or later

Feedback and Contribution:
Feel free to modify the script to suit your needs. If you have any suggestions or improvements, please let me know!
