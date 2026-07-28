#!/bin/bash

# Recursive function to draw the tree layout
draw_tree() {
    local target_dir="$1"
    local visual_indent="$2"
    
    # Enable dotglob to include hidden files/folders in the expansion
    shopt -s dotglob
    local dir_contents=("$target_dir"/*)
    shopt -u dotglob # Disable dotglob to keep default shell behavior elsewhere
    
    # Handle empty directory edge case
    [ -e "${dir_contents}" ] || return

    local count=${#dir_contents[@]}
    local current_index=0

    for item in "${dir_contents[@]}"; do
        ((current_index++))
        local base_item=$(basename "$item")
        
        # Explicitly skip current (.) and parent (..) directory links
        if [ "$base_item" == "." ] || [ "$base_item" == ".." ]; then
            continue
        fi
        
        # Check if it is the last item in the current folder level
        if [ "$current_index" -eq "$count" ]; then
            echo -e "${visual_indent}└── $base_item"
            if [ -d "$item" ]; then
                draw_tree "$item" "$visual_indent    "
            fi
        else
            echo -e "${visual_indent}├── $base_item"
            if [ -d "$item" ]; then
                draw_tree "$item" "$visual_indent│   "
            fi
        fi
    done
}

# Prompt user for target base path
read -p "Enter base folder path [Press Enter for current directory]: " input_path

# Fallback to current working directory if input is empty
if [ -z "$input_path" ]; then
    target_path=$(pwd)
else
    # Resolve relative paths (like ~ or .) to absolute paths
    target_path=$(eval echo "$input_path")
fi

# Validate that the requested path actually exists and is a folder
if [ ! -d "$target_path" ]; then
    echo "Error: '$target_path' is not a valid directory."
    exit 1
fi

# Execute starting at the verified path
echo "$target_path"
draw_tree "$target_path" ""

read -p "Press Enter to exit..."
