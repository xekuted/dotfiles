# dotfiles

Personal dotfiles for **Fedora Linux** running the **MangoWM** compositor (Wayland).

## Quickstart

One line to clone everything:

```bash
git clone https://github.com/xekuted/dotfiles.git
```

Then run the installer from inside the repo:

```bash
cd dotfiles
./install.sh
```

> The installer needs `sudo` (installs packages) and an internet connection.
> Existing configs are never overwritten — files are only copied if they don't exist yet.

## What `install.sh` does

1. **Updates the system** — `dnf update -y`
2. **Installs core packages** — `swaync`, `helix`, `kitty`, `loupe`, `nwg-look`, `adw-gtk3-theme`, `zoxide`, `zsh`, `yazi`, `rofi`
3. **Sets up MangoWM from Terra** — adds the Terra repo, then installs `mangowm`, `vibepanel`, `quickshell` and `obsidian` (all from Terra)
4. **Installs waypaper** from the `solopasha/hyprland` COPR for wallpaper management
5. **Installs Brave** — `brave-origin` from the official Brave RPM repo (repo file + GPG key added first)
6. **Installs Flatpaks** — Gear Lever, Stremio
7. **Clones mango-layout-switcher** (quickshell QML layout switcher) into `~/.config/quickshell`
8. **Copies the configs** — rsyncs `config/` into `~/.config/` with `--ignore-existing`
9. **Copies the wallpapers** — rsyncs `Wallpapers/` into `~/Pictures/Wallpapers/` (every config references this path)
10. **Sets zsh as the default shell** — `chsh -s "$(which zsh)"`

## Features

- **MangoWM** — a complete tiling-window-manager config: custom keybinds, workspaces/tags, window rules, autostart and an idle handler (locks the screen after 10 s idle with `swaylock`).
- **Swaync** notification daemon with a quick-settings panel: brightness/volume sliders, microphone toggle, wifi picker, lock, suspend and power-off buttons.
- **Vibepanel** — quickshell-based status bar (installed from Terra) with a layout switcher.
- **Kitty** terminal with a Gruvbox / CaskaydiaCove Nerd Font theme; `Alt+t` opens it.
- **Dark theme via nwg-look** — ships the *Adwaita* GTK theme (`adw-gtk3-dark`) with `gtk-3.0/settings.ini` + `gtk-4.0/settings.ini` already exported, so GTK apps start dark. Re-apply or tweak with `nwg-look` (or `nwg-look -a` to re-export from disk).
- **Zsh** + **zoxide** + **yazi** — fast navigation and file browsing in the terminal (`h` alias).
- **Loupe / Flameshot** for viewing and screenshotting; screenshots save to `~/Pictures`.
- **Rofi** launcher and power menu (`Alt+d` menu, `Alt+F4` power menu).
- **Swaylock** lock screen using `Wallpapers/minimalistic/light/chinese-hills.jpg` — used by the idle handler, the suspend script and the swaync lock button.
- **Scripts** under `config/mango/scripts/`:
  - `suspend.sh` — locks the screen, then suspends (`systemctl suspend`)
  - `powermenu.sh` — rofi power menu (Shutdown / Reboot / Suspend / Logout)
  - `logout.sh` — ends the Mango session
  - `wifi.sh` — opens the wifi picker (`~/wifi.py`)
  - `workflow.sh` — `Alt+w`: opens Obsidian, a kitty window running `dnf upgrade` + `dnf autoremove`, and Brave with your news/home links (skipped if Brave is already running)
  - `start-portal.sh` — starts the `xdg-desktop-portal` daemon for the session (Mango doesn't activate `graphical-session.target` itself)
- **100+ curated wallpapers** organised by category in `Wallpapers/`. The set mirrors `~/Pictures/Wallpapers`, so deleting an image there and re-running `install.sh` keeps the two in sync.
- **nwg-look** also manages the exported GTK settings (`~/.gtkrc-2.0`, `~/.icons/default/index.theme`, `xsettingsd`) — run `nwg-look -a` to re-apply exported files after changing `gtk-3.0/settings.ini`.

## Repository layout

```
dotfiles/
├── install.sh            # one-command setup script
├── requirements.txt      # package list
├── zshrc                 # shell config (install as ~/.zshrc)
├── config/               # per-app configs, rsynced into ~/.config/
│   ├── mango/            # MangoWM config + scripts
│   ├── swaync/           # notifications + quick settings
│   ├── vibepanel/        # quickshell bar config
│   ├── kitty/            # terminal config
│   ├── helix/            # editor config
│   ├── nwg-look/         # nwg-look export preferences
│   ├── gtk-3.0/          # GTK3 settings (dark Adwaita)
│   ├── gtk-4.0/          # GTK4 settings (dark Adwaita)
│   ├── flameshot/        # screenshot tool config
│   ├── rofi/             # launcher / power menu theme
│   └── ...
└── Wallpapers/           # wallpaper collection
```

## Maintenance notes

- Validate the Mango config after editing: `mango -p`
- Validate scripts with `bash -n` and JSON with `python3 -m json.tool`.
- Known keybind conflict (harmless warning on `mango -p`): `SUPER+ALT+Left/Right` is bound to both `exchange_client` and `tagmon`.