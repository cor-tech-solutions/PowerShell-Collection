# Function to get user and validate it
function Get-UserInput {
    while ($true) { # Loop until valid input or "exit" is entered.  
        $input = Read-Host "Enter an expression (e.g., 2 + 3, 10 * 5, 8 / 2, 7 - 4, or 'exit')"

        if ($input -eq "exit") {
            return $null # Signal to exit the script
        }

        # Use a regular expression to validate the input format.
        # The regex ensure the input is in the format "number operator number"
        # With optional whitespace around the numbers and operator. It also allows negative numbers and decimals.
        if ($input -match "^(\s*-?\d+(\.\d+)?\s*)([\+\-\*\/])(\s*-?\d+(\.\d+)?\s*)$") {
            return $input # Return the valid input.
        } else {
            Write-Host "Invalid input. Please use the format 'number operator number'."
        }
    } 
}

# Function to perform the calculation.
function Calculate-Result {
    param(
        [string]$expression # The expression to calculate
    )

    try {
        # Split the expression into operands and operator.
        # -split "([\+\-\*\/])" splits by the operators, keeping the operators in the result.
        # -replace "\s" removes any remaining whitespace.
        $parts = $expression -split "([\+\-\*\/])" -replace "\s"

        # Convert the operands to doubles to handle decimals.
        $operand1 = [double]$parts[0]

        $operator = $parts[1]

        $operand2 = [double]$parts[2]

        # Use a switch statement to perform the correct operation.
        switch ($operator) {
            "+" { return $operand1 + $operand2 }
            "-" { return $operand1 - $operand2 }
            "*" { return $operand1 * $operand2 }
            "/" {
                # Check for division by zero.
                if ($operand2 -eq 0) {
                    throw "Division by zero is not allowed."
                }
                return $operand1 / $operand2
            }
            # Should not happen due to regex check in Get-UserInput
            default { throw "Invalid operator."}
        }
    }
    catch {
        # Handle any errors that occur during calculation (e.g., division by zero)

        # Write the error message to the console.
        Write-Error $_.Exception.Message
        # Return null to indicate an error.
        return $null 
    }
}

# Main script loop.
Write-Host "Simple Calculator (Left-to-right evaluation - no order of operations)." # Important warning!
while ($true) {
    # Get user input.
    $userInput = Get-UserInput

    # Check if the user wants to exit.
    if ($userInput -eq $null) {
        Write-Host "Exiting calculator."
        break # Exit the main loop and the script.
    }

    # Calculate the result.
    $result = Calculate-Result -expression $userInput

    # Display the result if the calculation was successful.
    if ($result -ne $null) {
        Write-Host "Result: $result"
    }
}
