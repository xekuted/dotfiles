#!/usr/bin/env bash

# Permanent Rofi file finder mode
# Type to fuzzy-search files under $HOME, Enter opens them

if [ -z "$@" ]; then
    # First call: list files
    fd --type f --hidden \
       --exclude .git \
       --exclude node_modules \
       --exclude .cache \
       --exclude __pycache__ \
       --exclude .local/share/Trash \
       . "$HOME" 2>/dev/null
else
    # User selected something → open it
    xdg-open "$@" >/dev/null 2>&1 &
fi
