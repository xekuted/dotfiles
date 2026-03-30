#!/bin/bash

# Your base wallpaper directory
WALL_DIR="$HOME/Pictures/Wallpapers"

# Open Rofi in file-browser mode
# -show filebrowser: Opens the folder navigation
# -filebrowser-directory: Starts at your wallpaper folder
# -show-icons: Enables thumbnails (requires tumbler)
# -theme-str: Adjusts the layout to make thumbnails look good
SELECTED=$(rofi -show filebrowser \
  -filebrowser-directory "$WALL_DIR" \
  -show-icons \
  -theme-str 'element-icon { size: 5em; } listview { columns: 4; }' \
  -p "󰸉 Wallpapers")

# If an image was selected (and it's not a directory)
if [ -n "$SELECTED" ] && [ -f "$SELECTED" ]; then
  swww img "$SELECTED" --transition-type wipe --transition-duration 1
  echo "$SELECTED" >"$HOME/.current_wallpaper"
fi
