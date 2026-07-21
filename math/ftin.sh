#!/bin/bash

# Define the regex pattern to capture feet, inches, numerator, denominator
pattern="^([0-9]+)'-([0-9]+)[[:space:]]+([0-9]+)/([0-9]+)\"$"

# Function to parse a string and return total decimal inches
parse_to_inches() {
    local input="$1"
    if [[ "$input" =~ $pattern ]]; then
        local ft="${BASH_REMATCH[1]}"
        local in="${BASH_REMATCH[2]}"
        local num="${BASH_REMATCH[3]}"
        local den="${BASH_REMATCH[4]}"
        echo "scale=4; ($ft * 12) + $in + ($num / $den)" | bc
    else
        echo "ERROR"
    fi
}

# 1. Get user inputs
read -p "Enter the first measurement (e.g., 34'-7 7/8\"): " string1
read -p "Enter the second measurement (e.g., 12'-3 1/4\"): " string2

# 2. Parse both strings to decimal inches
inches1=$(parse_to_inches "$string1")
inches2=$(parse_to_inches "$string2")

if [ "$inches1" = "ERROR" ] || [ "$inches2" = "ERROR" ]; then
    echo "Error: One or both inputs were not in the correct format (X'-Y N/D\")."
    exit 1
fi

# 3. Calculate grand total in decimal inches
total_inches=$(echo "scale=4; $inches1 + $inches2" | bc)

# ==========================================
# CONVERSION LOGIC
# ==========================================

# Format 1: Decimal Feet (Total Inches / 12)
dec_feet=$(echo "scale=4; $total_inches / 12" | bc)

# Format 2: Decimal Inches
dec_inches=$total_inches

# Format 3: Feet-Inches-Sixteenths
# Get whole feet (integer division)
out_feet=$(echo "$total_inches / 12" | bc)

# Get remaining inches after removing whole feet
rem_inches=$(echo "$total_inches - ($out_feet * 12)" | bc)

# Get whole inches from that remainder
out_inches=$(echo ${rem_inches%.*}) # Strips everything after the decimal point
[ -z "$out_inches" ] && out_inches=0 # Fallback if empty

# Get the fractional part left over
frac_part=$(echo "$rem_inches - $out_inches" | bc)

# Convert fractional part to nearest 16th and round it
# We add 0.5 to simulate standard rounding in bc integer division
out_sixteenths=$(echo "scale=0; ($frac_part * 16 + 0.5) / 1" | bc)

# Handle potential rounding overflow (e.g., 16/16th becomes 1 full inch)
if [ "$out_sixteenths" -eq 16 ]; then
    out_sixteenths=0
    out_inches=$((out_inches + 1))
fi
if [ "$out_inches" -eq 12 ]; then
    out_inches=0
    out_feet=$((out_feet + 1))
fi

# ==========================================
# DISPLAY RESULTS
# ==========================================
echo -e "\n================ RESULTS ================"
echo "1. Decimal Feet:           ${dec_feet} ft"
echo "2. Decimal Inches:         ${dec_inches} in"
echo "3. Feet-Inches-Sixteenths: ${out_feet}'-${out_inches} ${out_sixteenths}/16\""
echo "========================================="
