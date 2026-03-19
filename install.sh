#!/usr/bin/env bash
# =============================================================================
# Dotfiles Install Script — Fedora & Arch Linux
# Usage: bash install.sh
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.dotfiles-install.log"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()     { echo -e "${CYAN}[dotfiles]${RESET} $*" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[✓]${RESET} $*"        | tee -a "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $*"        | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[✗]${RESET} $*"           | tee -a "$LOG_FILE"; }
header()  { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

symlink() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" || -L "$dst" ]]; then
        local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        warn "Backing up $dst → $bak"
        mv "$dst" "$bak"
    fi
    ln -s "$src" "$dst"
    success "Linked $src → $dst"
}

# ── Detect distro ─────────────────────────────────────────────────────────────
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            fedora)       DISTRO="fedora" ;;
            arch|manjaro) DISTRO="arch"   ;;
            *)
                error "Unsupported distro: $ID"
                exit 1
                ;;
        esac
    else
        error "Cannot detect distro — /etc/os-release not found"
        exit 1
    fi
    log "Detected distro: $DISTRO"
}

# ── Install packages ──────────────────────────────────────────────────────────
install_packages() {
    header "Installing packages"

    if [[ "$DISTRO" == "fedora" ]]; then
        install_packages_fedora
    else
        install_packages_arch
    fi
}

install_packages_fedora() {
    log "Updating system…"
    sudo dnf upgrade -y --refresh

    # mangowm lives in the Terra third-party repo on Fedora
    if ! rpm -q terra-release &>/dev/null; then
        log "Adding Terra repository (for mangowm)…"
        sudo dnf install -y --nogpgcheck \
            --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
            terra-release
    fi

    sudo dnf install -y \
        zsh \
        foot \
        mangowm \
        waybar \
        wofi \
        jrnl \
        neovim \
        alsa-utils \
        btop \
        flameshot \
        flatpak \
        gwenview \
        python3 \
        pavucontrol \
        rust \
        swaybg \
        swayidle \
        swaylock \
        swww \
        thunar \
        vlc \
        wf-recorder \
        telegram-desktop \
        ohmyposh

    success "DNF packages installed"
}

install_packages_arch() {
    log "Updating system…"
    sudo pacman -Syu --noconfirm

    # Install yay first using pacman + base-devel
    if ! command -v yay &>/dev/null; then
        log "Installing yay (AUR helper)…"
        sudo pacman -S --needed --noconfirm git base-devel
        local tmp; tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && makepkg -si --noconfirm)
        rm -rf "$tmp"
        success "yay installed"
    else
        success "yay already installed"
    fi

    # Install everything via yay (covers both official repos and AUR)
    # mangowm-git and oh-my-posh-bin are AUR; everything else is in extra/community
    yay -S --needed --noconfirm \
        zsh \
        foot \
        mangowm-git \
        waybar \
        wofi \
        jrnl \
        neovim \
        alsa-utils \
        btop \
        flameshot \
        flatpak \
        gwenview \
        python \
        pavucontrol \
        rust \
        swaybg \
        swayidle \
        swaylock \
        swww \
        thunar \
        vlc \
        wf-recorder \
        telegram-desktop \
        oh-my-posh-bin

    success "Arch packages installed"
}

# ── Flatpaks ──────────────────────────────────────────────────────────────────
install_flatpaks() {
    header "Installing Flatpaks"

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    flatpak install -y flathub com.stremio.Stremio
    flatpak install -y flathub dev.vencord.Vesktop

    success "Flatpaks installed"
}

# ── Oh My Zsh + plugins ───────────────────────────────────────────────────────
install_omz() {
    header "Setting up Oh My Zsh"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh…"
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        success "Oh My Zsh already installed"
    fi

    local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ ! -d "$custom/plugins/zsh-autosuggestions" ]]; then
        log "Installing zsh-autosuggestions…"
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$custom/plugins/zsh-autosuggestions"
    fi

    if [[ ! -d "$custom/plugins/zsh-syntax-highlighting" ]]; then
        log "Installing zsh-syntax-highlighting…"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "$custom/plugins/zsh-syntax-highlighting"
    fi

    success "Oh My Zsh + plugins ready"
}

# ── Oh My Posh theme ──────────────────────────────────────────────────────────
install_omp_theme() {
    header "Fetching Oh My Posh theme"

    local theme_dir="$HOME/.cache/oh-my-posh/themes"
    mkdir -p "$theme_dir"

    if [[ ! -f "$theme_dir/uew.omp.json" ]]; then
        log "Downloading uew theme…"
        curl -fsSL \
            "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/uew.omp.json" \
            -o "$theme_dir/uew.omp.json"
        success "Theme downloaded"
    else
        success "Theme already present"
    fi
}

# ── Symlink configs ───────────────────────────────────────────────────────────
install_configs() {
    header "Symlinking configs"

    symlink "$DOTFILES_DIR/zshrc"         "$HOME/.zshrc"
    symlink "$DOTFILES_DIR/config/nvim"   "$HOME/.config/nvim"
    symlink "$DOTFILES_DIR/config/waybar" "$HOME/.config/waybar"
    symlink "$DOTFILES_DIR/config/wofi"   "$HOME/.config/wofi"
    symlink "$DOTFILES_DIR/config/mango"  "$HOME/.config/mango"

    success "All configs symlinked"
}

# ── Default shell ─────────────────────────────────────────────────────────────
set_default_shell() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        header "Setting zsh as default shell"
        chsh -s "$(which zsh)"
        success "Default shell set to zsh — takes effect on next login"
    fi
}

# ── Entry point ───────────────────────────────────────────────────────────────
main() {
    echo -e "${BOLD}${CYAN}  dotfiles installer${RESET}"
    log "Starting — log: $LOG_FILE"

    detect_distro
    install_packages
    install_flatpaks
    install_omz
    install_omp_theme
    install_configs
    set_default_shell

    echo ""
    success "All done! Log out and back in to apply shell change."
}

main "$@"
