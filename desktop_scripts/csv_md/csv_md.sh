#!/bin/bash

# Ask user for the full path of the input file
read -p "Enter the full path of the input CSV file: " input_file

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Process the CSV file using awk to generate the Markdown structure
awk -F',' -f /dev/stdin "$input_file" << 'EOF_AWK'
# Function to trim leading/trailing whitespace
function trim(s) {
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    return s
}

# First pass: Store data and check which columns contain numbers
{
    if (NF > num_cols) num_cols = NF
    
    for (i = 1; i <= NF; i++) {
        val = trim($i)
        matrix[NR, i] = val
        
        # Check if columns contain non-numeric data below the header row
        if (NR > 1 && val != "") {
            if (val !~ /^[+-]?[0-9]*\.?[0-9]+$/) {
                is_numeric[i] = "no"
            } else if (is_numeric[i] != "no") {
                is_numeric[i] = "yes"
            }
        }
    }
    num_rows = NR
}

# Second pass: Render the Markdown table
END {
    for (r = 1; r <= num_rows; r++) {
        # Print the data or header row
        printf "|"
        for (c = 1; c <= num_cols; c++) {
            printf " %s |", matrix[r, c]
        }
        print ""
        
        # Print the fixed alignment separator line immediately after the header row
        if (r == 1) {
            printf "|"
            for (c = 1; c <= num_cols; c++) {
                if (is_numeric[c] == "yes") {
                    # Right-align format for numbers
                    printf "---:|"
                } else {
                    # Left-align format for text
                    printf ":---|"
                }
            }
            print ""
        }
    }
}
EOF_AWK


read -p "Press Enter to exit..."