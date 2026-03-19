#!/bin/bash

get_layout() {
  # This grabs the output and takes only the last word/character
  # If mmsg returns 'HDMI-A-1 G', this will just return 'G'
  layout=$(mmsg -g -l | awk '{print $NF}')

  # Optional: Map the letters to nice names or icons
  case $layout in
  "G") label="Grid" ;;
  "T") label="Tile" ;;
  "S") label="Scroll" ;;
  "M") label="Mono" ;;
  *) label="$layout" ;; # Fallback for unknown codes
  esac

  echo "{\"text\": \"$label\"}"
}

# Initial run
get_layout

# Monitor for changes
mmsg -w | while read -r line; do
  # Only update when a layout event occurs
  if echo "$line" | grep -q "layout"; then
    get_layout
  fi
done
