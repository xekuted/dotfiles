#!/bin/bash
#
# Copy tracked configs/wallpapers from this dotfiles repo into place,
# WITHOUT overwriting files that already exist (same as install.sh).
#
# Usage:
#   ./sync.sh            # configs + wallpapers
#   ./sync.sh --config   # configs only
#   ./sync.sh --wp       # wallpapers only
#   ./sync.sh --help

set -u

DOTFILES_DIR="$(dirname "$(realpath "$0")")"

sync_configs() {
  echo "=== Configs -> ~/.config (existing files kept) ==="
  if [ -d "$DOTFILES_DIR/config" ]; then
    mkdir -p ~/.config
    rsync -a --ignore-existing "$DOTFILES_DIR/config/" ~/.config/
  fi
}

sync_wallpapers() {
  echo "=== Wallpapers -> ~/Pictures/Wallpapers ==="
  if [ -d "$DOTFILES_DIR/Wallpapers" ]; then
    mkdir -p ~/Pictures
    rsync -a "$DOTFILES_DIR/Wallpapers/" ~/Pictures/Wallpapers/
  fi
}

case "${1:-}" in
  --config) sync_configs ;;
  --wp)     sync_wallpapers ;;
  --help|-h) grep '#   ' "$0" | sed 's/#   //' ;;
  '')       sync_configs; sync_wallpapers ;;
  *)        echo "Unknown option: $1"; echo "Run: $0 --help"; exit 1 ;;
esac

echo "=== Remember to check git status for changes to commit ==="
git -C "$DOTFILES_DIR" status --short | head -20