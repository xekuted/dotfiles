# dotfiles

## structure

```
dotfiles/
├── install.sh          ← run this on a fresh install
├── zshrc               ← symlinked to ~/.zshrc
└── config/
    ├── nvim/           ← symlinked to ~/.config/nvim/
    ├── waybar/         ← symlinked to ~/.config/waybar/
    ├── wofi/           ← symlinked to ~/.config/wofi/
    └── mango/          ← symlinked to ~/.config/mango/
```

## fresh install

```bash
sudo dnf install -y git
git clone https://github.com/YOURNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

## what it installs

- DNF packages: zsh, foot, mangowm, waybar, wofi, jrnl, neovim, btop, flameshot, pavucontrol, swaybg, swayidle, swaylock, swww, thunar, vlc, wf-recorder, telegram-desktop, gwenview, python3, rust, ohmyposh
- Flatpaks: Stremio, Vesktop
- Oh My Zsh + zsh-autosuggestions + zsh-syntax-highlighting
- Oh My Posh (uew theme)
- Symlinks all configs above
- Sets zsh as default shell
