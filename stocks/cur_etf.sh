#!/bin/bash
DOWNLOADS_DIR="/home/ts/Downloads"
FILE_PATTERN="All-Accounts-Positions-*.csv"
# Updated to save directly to your Desktop
OUTPUT_FILE="/home/ts/Desktop/filtered_output.csv"

# Find the latest file
INPUT_FILE=$(ls "$DOWNLOADS_DIR"/$FILE_PATTERN 2>/dev/null | sort | tail -n 1)

if [ -z "$INPUT_FILE" ]; then
    echo "Error: No matching CSV files found in $DOWNLOADS_DIR"
    exit 1
fi

echo "Processing the latest file: $INPUT_FILE"

# Process the CSV file
awk '
BEGIN {
    FPAT = "([^,]*)|(\"[^\"]*\")"
    OFS = ","
    # State tracking variables
    ignore_account = 0
    printed_header = 0
}
{
    # Clean up hidden Windows carriage returns (\r)
    gsub(/\r/, "", $0)

    # Detect account lines
    is_account_line = ($0 ~ /^"[A-Za-z0-9_ -]+ \.\.\.[0-9]+"$/) || ($0 ~ /^"Taxable Account"$/)
    
    if (is_account_line) {
        # Check if this is the account we want to skip
        if ($0 ~ /Indiv_Josh/) {
            ignore_account = 1
        } else {
            ignore_account = 0
            print $0  # Print valid account name
        }
        next  # Skip to next line immediately
    }

    # Skip everything if we are inside the Josh account block
    if (ignore_account) {
        next
    }

    # Handle the column headers row (Symbol, Description, Mkt Val, Cost Basis)
    if ($1 ~ /"?Symbol"?/) {
        if (!printed_header) {
            # Added $13 for the Cost Basis header
            print $1, $2, $10, $13
            printed_header = 1
        }
        next
    }

    # Filter and extract data rows for ETFs (Ensuring at least 13 fields exist)
    if (NF >= 13) {
        matched = 0
        for (i = 10; i <= NF; i++) {
            if ($i ~ /"?[ \t]*ETFs & Closed End Funds[ \t]*"?/) {
                matched = 1
                break
            }
        }
        if (matched) {
            # Added $13 to print the Cost Basis field value
            print $1, $2, $10, $13
        }
    }
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Success! Filtered data has been saved to: $OUTPUT_FILE"

read -p "Press Enter to close this terminal..."