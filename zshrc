# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 15

DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
compinit

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# PATH
export PATH=/home/$USER/.opencode/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Aliases
alias j="jrnl"
alias n="nvim"
alias fp="flatpak"
alias qsh="qs -c /etc/xdg/quickshell/noctalia-shell"

# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/uew.omp.json)"
