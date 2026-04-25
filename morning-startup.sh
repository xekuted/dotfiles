#!/bin/bash

# Browser
nohup brave-browser --new-window \
  "https://upskill.tutedude.com/course/lecture-mernstack" \
  "https://techcrunch.com/" \
  "https://www.artificialintelligence-news.com/" \
  "https://arstechnica.com/" \
  "https://arxiv.org/" \
  "https://www.hackerrank.com/dashboard" \
  >/dev/null 2>&1 &

# Obsidian (Flatpak)
nohup flatpak run md.obsidian.Obsidian >/dev/null 2>&1 &

# Neovim in WezTerm
nohup flatpak run org.wezfurlong.wezterm start --always-new-process -- nvim ~/Proj/fokus +"10split | terminal" \
  >/dev/null 2>&1 &

# System update in a separate WezTerm
nohup flatpak run org.wezfurlong.wezterm start --always-new-process -- bash -c "sudo dnf update -y && sudo dnf upgrade -y && sudo dnf autoremove" \
  >/dev/null 2>&1 &
