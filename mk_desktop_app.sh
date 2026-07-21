echo -e "This script will create a shortcut to a program on the Desktop\n"
echo "User Input:"
read -p "   Input the name of the program: " prg_name
read -p "   Enter full pathname of the script/executable: " prg
read -p "   Enter full pathname of the optional icon (or enter blank) .png: " icon
echo
echo -e "\nYou Entered the following:"
echo "   program name:   " $prg_name
echo "   prog full path: " $prg
echo "   prog icon:      " $icon
echo
read -p "proceed with creating the desktop program (y/n): " user_confirmation

if [[ "$user_confirmation" == 'n' || "$user_confirmation" == 'N' ]]; then
   echo "User Cancelled the script, exiting script"
   exit 0
fi

{
   echo "[Desktop Entry]"
   echo "Type=Application"
   echo "Name=$prg_name"
   echo "Exec=bash -i $prg"

   if [ -n "$icon" ]; then
       echo "Icon="$icon
   fi
   echo "Terminal=true"
} > ~/Desktop/$prg_name.desktop

echo "Desktop shortcut file created as follows:"
echo
echo "~/Desktop/"$prg_name".desktop:"
echo
cat ~/Desktop/$prg_name.desktop
echo
# Loop through both target files sequentially
for target in ~/Desktop/"$prg_name".desktop "$prg"; do
    # Check if the target file actually exists first
    if [ -e "$target" ]; then
        if chmod +x "$target"; then
            echo "✅ Success: Executable permission added to $target"
        else
            echo "❌ Error: Failed to change permissions for $target"
        fi
    else
        echo "⚠️ Warning: File does not exist: $target"
    fi
done

# Mark the file as trusted in the GNOME metadata
echo
echo -e "Next the script will set the desktop file as trusted, equiv to rt click allow launching"
gio set ~/Desktop/$prg_name.desktop metadata::trusted true
read -p "Press [Enter] key to continue..."