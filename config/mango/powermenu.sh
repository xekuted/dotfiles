#!/bin/bash

# Define the options with icons
options="󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰈆 Logout"

# Run wofi and strip icons/extra spaces to get just the word
choice=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" | sed 's/.* //')

case $choice in
Shutdown)
  systemctl poweroff
  ;;
Reboot)
  systemctl reboot
  ;;
Suspend)
  swaylock -f -i ~/Pictures/Wallpapers/wallpaper.jpg && systemctl suspend
  ;;
Logout)
  # Using the standard pkill to ensure it exits MangoWC
  pkill mango
  ;;
*)
  exit 1
  ;;
esac
