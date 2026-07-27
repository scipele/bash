#!/bin/bash

SCRIPTS_DIR="/home/dev/bash/desktop_scripts"
DESKTOP_DIR="/home/ts/Desktop"

# 1. Find and make all .sh files executable in the bash scripts directory
echo "Updating permissions for .sh files in $SCRIPTS_DIR..."
find "$SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} +

# 2. Find and make all .desktop files executable in the desktop directory
echo "Updating permissions for .desktop files in $DESKTOP_DIR..."
find "$DESKTOP_DIR" -type f -name "*.desktop" -exec chmod +x {} +

echo "Permissions updated successfully."
read -p "Press any key to continue..."