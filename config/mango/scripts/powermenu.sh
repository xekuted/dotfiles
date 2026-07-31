#!/bin/bash

# Define options
options="󰐥 Shutdown
󰜉 Reboot
󰤄 Suspend
󰈆 Logout"

# Show rofi menu
choice=$(echo -e "$options" | rofi -dmenu -p "Power Menu")

case "$choice" in
*"Shutdown")
  systemctl poweroff
  ;;
*"Reboot")
  systemctl reboot
  ;;
*"Suspend")
  swaylock -f -i ~/Pictures/Wallpapers/wallpaper.jpg && systemctl suspend
  ;;
*"Logout")
  pkill mango
  ;;
*)
  exit 1
  ;;
esac
