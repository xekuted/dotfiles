#!/bin/bash

set -e

echo "=== Updating system (because Fedora gonna Fedora) ==="
sudo dnf update -y

echo "=== Installing core packages ==="
sudo dnf install -y \
  waybar \
  swaync \
  neovim \
  zoxide \
  zsh \
  yazi \
  rofi \
  base-devel

echo "=== Adding Terra repo + installing MangoWM ==="
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y
sudo dnf install -y mangowm

echo "=== Adding COPR repos ==="
sudo dnf copr enable -y solopasha/hyprland
sudo dnf copr enable -y prankstr/vibepanel

echo "=== Installing waypaper and vibepanel (quickshell comes as dependency) ==="
sudo dnf install -y waypaper vibepanel

echo "=== Installing Flatpaks in one clean command ==="
flatpak install -y flathub \
  com.brave.Browser \
  org.wezfurlong.wezterm \
  it.mijorus.gearlever \
  com.stremio.Stremio \
  dev.vencord.Vesktop \
  md.obsidian.Obsidian

echo "=== Installing wswitch (the only thing that needs compiling) ==="
git clone https://github.com/DreamMaoMao/wswitch.git /tmp/wswitch
cd /tmp/wswitch
makepkg -si --noconfirm
cd -
rm -rf /tmp/wswitch

echo "=== Installing mango-layout-switcher (Quickshell QML panel) ==="
mkdir -p ~/.config/quickshell
git clone https://github.com/atheeq-rhxn/mango-layout-switcher.git ~/.config/quickshell/mango-layout-switcher

echo "=== Copying configs from dotfiles/config to ~/.config ==="
DOTFILES_CONFIG="$(dirname "$(realpath "$0")")"
if [ -d "$DOTFILES_CONFIG/config" ]; then
  mkdir -p ~/.config
  rsync -av --ignore-existing "$DOTFILES_CONFIG/config/" ~/.config/
fi

echo "=== Moving workflow.sh to ~/.local/bin and making it executable ==="
mkdir -p ~/.local/bin
DOTFILES_DIR="$(dirname "$(realpath "$0")")"
if [ -f "$DOTFILES_DIR/workflow.sh" ]; then
  cp "$DOTFILES_DIR/workflow.sh" ~/.local/bin/
  chmod +x ~/.local/bin/workflow.sh
fi

echo "=== Setting zsh as default shell because you're too lazy ==="
chsh -s "$(which zsh)" "$USER" || echo "→ chsh failed (run manually later)"
