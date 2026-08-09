export PATH="/usr/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
# PATH
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# OH MY ZSH SETUP
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

# Plugins (ONLY names here)
plugins=(git)

# Load Oh My Zsh (guarded)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Fedora plugins (guarded)
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# OH MY POSH
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.poshthemes/uew.omp.json)"
fi

# USER SETTINGS
export EDITOR="zed"

# ALIASES
alias h="hx"
alias fp="flatpak"
alias j="jrnl"
alias oc="opencode"
alias oy="./ody.sh"
alias yz="yazi"

# ZOXIDE
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# COMPLETIONS
autoload bashcompinit
bashcompinit

[[ -f "$HOME/.local/share/bash-completion/completions/am" ]] && \
    source "$HOME/.local/share/bash-completion/completions/am"

export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share:$XDG_DATA_DIRS

fpath+=~/.zfunc

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select

# opencode
export PATH="$HOME/.opencode/bin:$PATH"