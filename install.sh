#!/bin/bash
#
# MangoWM dotfiles installer (Fedora)
#
# Order matters: everything installable through package managers runs first,
# so even if a manual download/build fails later, the installed software is
# already in place. Errors never abort the script; failures are logged and
# summarized at the end (non-zero exit if any step failed).

set -u
set -o pipefail

# --- Logging ---------------------------------------------------------------
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-install"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install.log"
: >"$LOG_FILE"

FAILED=0
FAILED_STEPS=()

# run_step <label> <command...>
run_step() {
  local label="$1"
  shift
  echo ""
  if ! { echo "=== $label ==="; "$@"; } 2>&1 | tee -a "$LOG_FILE"; then
    echo "--- $label : FAILED (continuing)"
    FAILED=1
    FAILED_STEPS+=("$label")
  else
    echo "--- $label : OK"
  fi
}

# Deterministic home dir reference (rsync/cp targets below)
DOTFILES_DIR="$(dirname "$(realpath "$0")")"

# ============================================================================
echo "################################################################"
echo "#  Installer pauses for nothing; failures are logged, not fatal. #"
echo "################################################################"
echo "Log: $LOG_FILE"
echo ""

# ---------------------------------------------------------------------------
# PART 1 - Everything installable via package managers
# ---------------------------------------------------------------------------

run_step "Updating system" sudo dnf update -y

run_step "Installing core packages" sudo dnf install -y \
  swaync \
  fd-find \
  helix \
  jq \
  kitty \
  loupe \
  nwg-look \
  adw-gtk3-theme \
  zoxide \
  zsh \
  yazi \
  rofi \
  swaylock \
  swayidle \
  brightnessctl \
  thunar \
  thunar-archive-plugin \
  xarchiver \
  python3-requests

step_terra() {
  sudo dnf install --nogpgcheck \
    --repofrompath "terra,https://repos.fyralabs.com/terra\$releasever" \
    terra-release -y
}

step_terra_packages() {
  sudo dnf install -y mangowm vibepanel quickshell obsidian awww
}

step_waypaper() {
  sudo dnf copr enable -y solopasha/hyprland
  sudo dnf install -y waypaper
}

step_brave() {
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
}

step_flatpaks() {
  flatpak install -y flathub \
    it.mijorus.gearlever \
    com.stremio.Stremio
}

run_step "Adding Terra repo" step_terra
run_step "Installing MangoWM, vibepanel, quickshell, Obsidian, awww (Terra)" step_terra_packages
run_step "Installing waypaper (COPR solopasha/hyprland)" step_waypaper
run_step "Installing Brave (official Brave RPM repo)" step_brave
run_step "Installing Flatpaks (gearlever, stremio)" step_flatpaks

# ---------------------------------------------------------------------------
# PART 2 - Copies: configs, wallpapers, icons, wifi helper
# ---------------------------------------------------------------------------

step_poshthemes() {
  if [ -f "$DOTFILES_DIR/poshthemes/uew.omp.json" ]; then
    mkdir -p ~/.poshthemes
    cp "$DOTFILES_DIR/poshthemes/uew.omp.json" ~/.poshthemes/uew.omp.json
  fi
}

step_configs() {
  if [ -d "$DOTFILES_DIR/config" ]; then
    mkdir -p ~/.config
    rsync -av --ignore-existing "$DOTFILES_DIR/config/" ~/.config/
  fi
}

step_wallpapers() {
  if [ -d "$DOTFILES_DIR/Wallpapers" ]; then
    mkdir -p ~/Pictures
    rsync -a "$DOTFILES_DIR/Wallpapers/" ~/Pictures/Wallpapers/
  fi
}

step_icons() {
  if [ -d "$DOTFILES_DIR/icons" ]; then
    mkdir -p ~/.local/share/icons
    rsync -a "$DOTFILES_DIR/icons/" ~/.local/share/icons/
  fi
}

step_wifi() {
  if [ -f "$DOTFILES_DIR/wifi.py" ]; then
    cp "$DOTFILES_DIR/wifi.py" ~/wifi.py
    chmod +x ~/wifi.py
  fi
  if [ ! -f ~/.config/wifi.env ]; then
    mkdir -p ~/.config
    cat > ~/.config/wifi.env <<'EOF'
# Wi-Fi (Sophos captive portal) credentials — wifi.codelif.in
# Fill these in; this file is yours, read-only and never committed.
WIFI_USER=your_username
WIFI_PASS=your_password
EOF
    chmod 600 ~/.config/wifi.env
  fi
}

run_step "Copying oh-my-posh theme (uew)" step_poshthemes
run_step "Copying configs to ~/.config" step_configs
run_step "Copying wallpapers to ~/Pictures/Wallpapers" step_wallpapers
run_step "Installing YaruExtDarkPurple icon theme" step_icons
run_step "Installing wifi.py + seeding ~/.config/wifi.env" step_wifi

# ---------------------------------------------------------------------------
# PART 3 - Manual downloads/builds (always run last)
# ---------------------------------------------------------------------------

step_ohmyposh() {
  if command -v oh-my-posh >/dev/null 2>&1; then
    echo "oh-my-posh already installed"
  else
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi
}

step_mango_layout_switcher() {
  local dest="$HOME/.config/quickshell/mango-layout-switcher"
  if [ -d "$dest" ]; then
    echo "mango-layout-switcher already present at $dest"
  else
    mkdir -p ~/.config/quickshell
    git clone https://github.com/atheeq-rhxn/mango-layout-switcher.git "$dest"
  fi
}

step_wswitch() {
  # Build deps for DreamMaoMao/wswitch (wayland+cairo+pango+json-c+glib)
  sudo dnf install -y \
    gcc \
    make \
    pkgconf-pkg-config \
    wayland-devel \
    wayland-protocols-devel \
    cairo-devel \
    pango-devel \
    json-c-devel \
    libxkbcommon-devel \
    glib2-devel

  rm -rf /tmp/wswitch
  git clone --depth 1 https://github.com/DreamMaoMao/wswitch.git /tmp/wswitch
  make -C /tmp/wswitch
  sudo make -C /tmp/wswitch install PREFIX=/usr
  wswitch-install-config
}

step_zsh() {
  if command -v zsh >/dev/null 2>&1; then
    chsh -s "$(which zsh)" "$USER"
  else
    echo "zsh not installed; skipping chsh"
  fi
}

run_step "Installing oh-my-posh" step_ohmyposh
run_step "Installing mango-layout-switcher (Quickshell panel)" step_mango_layout_switcher
run_step "Building wswitch (Alt+Tab app switcher)" step_wswitch
run_step "Setting zsh as default shell" step_zsh

# ---------------------------------------------------------------------------
# PART 4 - Summary
# ---------------------------------------------------------------------------
echo ""
echo "###############"
echo "# SUMMARY      #"
echo "###############"
if [ "$FAILED" -eq 1 ]; then
  echo "Failed steps:" >&2
  for s in "${FAILED_STEPS[@]}"; do
    echo "  - $s" >&2
  done
  echo "Full log: $LOG_FILE" >&2
  exit 1
else
  echo "All steps completed. Log: $LOG_FILE"
  exit 0
fi