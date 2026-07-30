#!/bin/bash
# remove and duplicated items that are already included in f1.csv from f2.csv and save the result to f2_cleaned.csv

read -p "This script will remove duplicates from f2.csv that are already present in f1.csv. Press enter to continue or Ctrl+C to cancel." key

# Check if both files exist
if [[ ! -f f1.csv ]] || [[ ! -f f2.csv ]]; then
    echo "Error: f1.csv or f2.csv not found."
    exit 1
fi

# Use awk to filter f2.csv based on values in f1.csv
awk -F, '
    NR==FNR { seen[$0]; next } 
    !($0 in seen)
' f1.csv f2.csv > f2_cleaned.csv

echo "Done! Cleaned file saved as f2_cleaned.csv"

read -p "Press enter to exit"