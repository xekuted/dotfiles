#!/bin/bash

nohup obsidian >/dev/null 2>&1 &

nohup kitty --hold -- bash -c "sudo dnf upgrade -y && sudo dnf autoremove -y" \
  >/dev/null 2>&1 &

if ! pgrep -x brave >/dev/null; then
  nohup brave-origin --new-window \
    "https://techcrunch.com/" \
    "https://www.artificialintelligence-news.com/" \
    "https://chat.deepseek.com/" \
    "https://claude.ai/new" \
    >/dev/null 2>&1 &
fi
