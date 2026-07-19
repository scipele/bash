#!/bin/bash

# ==========================================
# DEFINE YOUR SEARCH AND REPLACEMENT STRINGS
# ==========================================
echo "This script loops thru all (.docx and .xlsx) files and replaces the text strings as noted in the REPLACEMENTS section"
echo "- Step 1: program temporarily unzips the contents of the Microsoft zip format into a temp_dir"
echo "- Step 2: uses sed - to replace the text in the 'REPLACEMENTS' sections in a loop"
echo "- Step 3: re-zips the files"
echo -e "by jas, 7/18/2026\n"

declare -A REPLACEMENTS=(
    ["\$client_name"]="Company ABC"
    ["\$proj_title"]="Project Ghost Rider"
    ["\$proposal_date"]="July 27, 2026"
)

# Find all .docx and .xlsx files in the current directory
find . -maxdepth 1 \( -name "*.docx" -o -name "*.xlsx" \) | while read -r file; do
    echo "Processing: $file"
    
    # Identify extension to target the correct XML file path
    ext="${file##*.}"
    xml_target=""
    
    if [ "$ext" = "docx" ]; then
        xml_target="word/document.xml"
    elif [ "$ext" = "xlsx" ]; then
        xml_target="xl/sharedStrings.xml"
    fi

    # Create a unique temporary directory name
    temp_dir="temp_extract_$(date +%s%N)"
    mkdir "$temp_dir"
    
    # 1. Unzip the file quietly into the temp directory
    unzip -q "$file" -d "$temp_dir"
    
    # 2. Use sed to replace the text inside the targeted XML file
    if [ -n "$xml_target" ] && [ -f "$temp_dir/$xml_target" ]; then
        # Loop through each search key in the array
        for search in "${!REPLACEMENTS[@]}"; do
            replace="${REPLACEMENTS[$search]}"
            # how can i echo if the search string is found in the xml_target file?
            if grep -q "$search" "$temp_dir/$xml_target"; then
                echo "Found '$search' in $xml_target, replacing with '$replace'."
            else
                echo "Warning: '$search' not found in $xml_target."
            fi
            # Escape slashes in the replacement string to prevent sed errors
            escaped_replace=$(echo "$replace" | sed 's/\//\\\//g')
            
            # Run sed dynamically for the current pair
            sed -i "s/$search/$escaped_replace/g" "$temp_dir/$xml_target"
        done
    else
        echo "Warning: Target text file not found inside $file structure."
    fi
    
    # 3. Re-zip the contents back into the original file name
    (cd "$temp_dir" && zip -q -r "../$file" .)
    
    # Clean up the temp directory
    rm -rf "$temp_dir"
    
    echo "Finished: $file"
done
