# Workspace .zshrc — sourced by zsh on login
# Managed by: https://github.com/patleeman/dd.dotfiles

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true
ZSH_PYENV_QUIET=true

plugins=(git fzf vi-mode)

VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=false

source $ZSH/oh-my-zsh.sh
RPROMPT="\$(vi_mode_prompt_info)$RPROMPT"

# --- Editor ---
export EDITOR=nvim
export VISUAL=nvim

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# Linuxbrew (if installed)
if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Datadog paths ---
export DATADOG_ROOT="$HOME/dd"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$DATADOG_ROOT/devtools/bin:$PATH"
export GOPRIVATE=github.com/DataDog
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io
export GO111MODULE=auto

# --- Aliases ---
alias lg="lazygit"
alias gs="git status"
alias ga="git add ."
alias gb="git branch"
alias vim="nvim"
alias vi="nvim"
alias k="kubectl"
alias wd="cd ~/dd/"
alias dds="cd ~/dd/dd-source"
alias du="du -ach | sort -h"
alias ps="ps aux"
alias mkdir="mkdir -pv"

# ls via eza if available
if command -v eza &>/dev/null; then
    alias ls="eza -a"
elif command -v exa &>/dev/null; then
    alias ls="exa -la"
else
    alias ls="ls -la --color=auto"
fi
alias ll="/bin/ls"

# --- History ---
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# --- FZF ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if command -v fzf &>/dev/null; then
    # Use fd if available
    if command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    elif command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    fi
fi

# --- NVM/Volta (if installed) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export VOLTA_HOME="$HOME/.volta"
[ -d "$VOLTA_HOME" ] && export PATH="$VOLTA_HOME/bin:$PATH"

# --- Local overrides (not in git) ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
