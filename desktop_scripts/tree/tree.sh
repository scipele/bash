#!/bin/bash

# Recursive function to draw the tree layout
draw_tree() {
    local target_dir="$1"
    local visual_indent="$2"

    # Conditionally enable dotglob based on user preference
    if [ "$show_hidden" == "y" ]; then
        shopt -s dotglob
    fi
    
    local dir_contents=("$target_dir"/*)
    
    # Always disable dotglob after expansion to keep default shell behavior
    shopt -u dotglob

    # Handle empty directory edge case
    [ -e "${dir_contents[0]}" ] || return

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

# Ask user if they want to show hidden items
read -p "Show hidden items? (y/N): " choice
# Convert response to lowercase and default to 'n' if empty
show_hidden=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

# Execute starting at the verified path
echo "$target_path"
draw_tree "$target_path" ""

read -p "Press Enter to exit..."