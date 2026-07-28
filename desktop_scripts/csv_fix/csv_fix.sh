#!/bin/bash

# Ask user for the full path of the input file
read -p "Enter the full path of the input CSV file: " input_file

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Feeding the script into awk via standard input
awk -F',' -f /dev/stdin "$input_file" << 'EOF_AWK'
# Function to trim leading/trailing whitespace
function trim(s) {
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    return s
}

# Function to print the horizontal line separator
function print_separator() {
    for (i = 1; i <= num_cols; i++) {
        printf "+"
        for (j = 1; j <= maxlen[i] + 2; j++) {
            printf "-"
        }
    }
    print "+"
}

# First pass: Store data and calculate maximum widths
{
    if (NF > num_cols) num_cols = NF
    
    for (i = 1; i <= NF; i++) {
        val = trim($i)
        len = length(val)
        if (len > maxlen[i]) {
            maxlen[i] = len
        }
        matrix[NR, i] = val
    }
    num_rows = NR
}

# Second pass: Render the ASCII table
END {
    # 1. Print the top border
    print_separator()
    
    for (r = 1; r <= num_rows; r++) {
        # Print the data row
        for (c = 1; c <= num_cols; c++) {
            val = matrix[r, c]
            
            # Keep row 1 (headers) and all non-numeric text left-aligned
            if (r > 1 && val ~ /^[+-]?[0-9]*\.?[0-9]+$/) {
                # Right-aligned for numbers (uses maxlen[c] to specify width dynamically)
                printf "| %*s ", maxlen[c], val
            } else {
                # Left-aligned for text and headers
                printf "| %-" maxlen[c] "s ", val
            }
        }
        print "|"
        
        # 2. Print a separator immediately after the header row (row 1)
        if (r == 1) {
            print_separator()
        }
    }
    
    # 3. Print the final bottom border
    print_separator()
}
EOF_AWK

read -p "Press Enter to exit..."