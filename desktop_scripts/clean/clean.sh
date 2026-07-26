echo "This script cleans up you ubuntu installation:"
sudo apt autoremove
sudo apt autoclean
sudo apt clean
sudo journalctl --vacuum-time=7d
sudo apt autoclean
sudo apt autoremove
sudo journalctl --disk-usageClear
sudo journalctl --vacuum-time=3d
rm -rf ~/.cache/thumbnails/*
sudo snap remove --purge $(snap list --all | awk '/disabled/ {print $1}')
echo "Successfully cleaned the system"
read -p "Press [Enter] key to continue..."
