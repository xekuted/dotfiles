#!/bin/bash

# Obsidian (Flatpak)
nohup flatpak run md.obsidian.Obsidian >/dev/null 2>&1 &

# System update in a separate WezTerm
nohup flatpak run org.wezfurlong.wezterm start --always-new-process -- bash -c "sudo dnf upgrade -y && sudo dnf autoremove -y" \
  >/dev/null 2>&1 &

if ! pgrep -x brave-origin >/dev/null; then
  nohup brave-origin --new-window \
    "https://techcrunch.com/" \
    "https://www.artificialintelligence-news.com/" \
    "https://chat.deepseek.com/" \
    "https://claude.ai/new" \
    >/dev/null 2>&1 &
fi
