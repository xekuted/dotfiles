#!/bin/bash

set -e

echo "=== Updating system (because Fedora gonna Fedora) ==="
sudo dnf update -y

echo "=== Installing core packages ==="
sudo dnf install -y \
  swaync \
  helix \
  kitty \
  loupe \
  nwg-look \
  adw-gtk3-theme \
  zoxide \
  zsh \
  yazi \
  rofi

echo "=== Adding Terra repo + installing MangoWM, vibepanel, quickshell and Obsidian (all from Terra) ==="
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y
sudo dnf install -y mangowm vibepanel quickshell obsidian

echo "=== Adding waypaper from COPR ==="
sudo dnf copr enable -y solopasha/hyprland
sudo dnf install -y waypaper

echo "=== Installing oh-my-posh (prompt theme engine) ==="
command -v oh-my-posh >/dev/null 2>&1 || curl -s https://ohmyposh.dev/install.sh | bash -s

echo "=== Installing Brave (brave-origin from the official Brave RPM repo) ==="
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo tee /etc/yum.repos.d/brave-browser.repo >/dev/null <<'EOF'
[brave-browser]
name=Brave Browser
enabled=1
gpgcheck=1
gpgkey=https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
baseurl=https://brave-browser-rpm-release.s3.brave.com/$basearch
EOF
sudo dnf install -y brave-origin

echo "=== Installing Flatpaks in one clean command ==="
flatpak install -y flathub \
  it.mijorus.gearlever \
  com.stremio.Stremio

echo "=== Installing mango-layout-switcher (Quickshell QML panel) ==="
mkdir -p ~/.config/quickshell
git clone https://github.com/atheeq-rhxn/mango-layout-switcher.git ~/.config/quickshell/mango-layout-switcher

echo "=== Copying oh-my-posh theme (uew) to ~/.poshthemes ==="
DOTFILES_THEME="$(dirname "$(realpath "$0")")"
if [ -f "$DOTFILES_THEME/poshthemes/uew.omp.json" ]; then
  mkdir -p ~/.poshthemes
  cp "$DOTFILES_THEME/poshthemes/uew.omp.json" ~/.poshthemes/uew.omp.json
fi

echo "=== Copying configs from dotfiles/config to ~/.config ==="
DOTFILES_CONFIG="$(dirname "$(realpath "$0")")"
if [ -d "$DOTFILES_CONFIG/config" ]; then
  mkdir -p ~/.config
  rsync -av --ignore-existing "$DOTFILES_CONFIG/config/" ~/.config/
fi

echo "=== Copying wallpapers to ~/Pictures/Wallpapers (configs reference these) ==="
DOTFILES_DIR="$(dirname "$(realpath "$0")")"
if [ -d "$DOTFILES_DIR/Wallpapers" ]; then
  mkdir -p ~/Pictures
  rsync -a "$DOTFILES_DIR/Wallpapers/" ~/Pictures/Wallpapers/
fi

echo "=== Setting zsh as default shell because you're too lazy ==="
chsh -s "$(which zsh)" "$USER" || echo "→ chsh failed (run manually later)"
