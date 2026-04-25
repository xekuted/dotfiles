#!/bin/bash

echo "Starting morning workflow..."

# Browser
nohup brave-browser --new-window \
  "https://techcrunch.com/" \
  "https://www.artificialintelligence-news.com/" \
  "https://arstechnica.com/" \
  "https://arxiv.org/" \
  "https://www.hackerrank.com/dashboard" \
  >/dev/null 2>&1 &

# Obsidian (Flatpak)
nohup flatpak run md.obsidian.Obsidian >/dev/null 2>&1 &

# Neovim in terminal
nohup flatpak run org.wezfurlong.wezterm start -- nvim /home/xek/Proj/fokus +"10split | terminal" \
  >/dev/null 2>&1 &

echo "Done."
