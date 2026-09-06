#!/usr/bin/env bash

if [ -z "$@" ]; then
    fd --type f --hidden \
       --exclude .git \
       --exclude node_modules \
       --exclude .cache \
       --exclude __pycache__ \
       --exclude .local/share/Trash \
       . "$HOME" 2>/dev/null
else
    file="$@"

    case "${file,,}" in
        *.txt|*.md|*.conf|*.rasi|*.toml|*.yaml|*.yml|*.json|*.sh|*.bash|*.zsh|*.py|*.js|*.ts|*.rs|*.go|*.c|*.h|*.cpp|*.hpp|*.css|*.html|*.xml|*.ini|*.cfg|*.env|*.log|*.desktop)
            kitty -e hx "$file" >/dev/null 2>&1 &
            ;;
        *)
            xdg-open "$file" >/dev/null 2>&1 &
            ;;
    esac

    # Force Rofi to close
    exit 0
fi
