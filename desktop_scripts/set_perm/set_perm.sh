#!/bin/bash

# 1. Find and make all .sh files executable in the bash scripts directory
find /home/dev/bash/desktop_scripts -type f -name "*.sh" -exec chmod +x {} +

# 2. Find and make all .desktop files executable in the desktop directory
find /home/ts/Desktop -type f -name "*.desktop" -exec chmod +x {} +

echo "Permissions updated successfully."
read -p "Press any key to continue..."