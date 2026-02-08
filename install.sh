#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
LOG_PREFIX="[dd.dotfiles]"

log() { echo "$LOG_PREFIX $*"; }
log_section() { echo ""; echo "$LOG_PREFIX === $* ==="; }

# --- Oh My Zsh ---
log_section "Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log "Oh My Zsh already installed"
fi

# --- apt packages ---
log_section "apt packages"
sudo apt-get update -qq
sudo apt-get install -y -qq \
    stow \
    fzf \
    ripgrep \
    fd-find \
    jq \
    tmux \
    htop \
    tree \
    unzip \
    make \
    build-essential \
    wget \
    2>&1 | tail -1

# --- GitHub CLI (gh) ---
log_section "GitHub CLI"
if ! command -v gh &>/dev/null; then
    log "Installing gh..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq gh 2>&1 | tail -1
else
    log "gh already installed: $(gh --version | head -1)"
fi

# --- Neovim (latest stable via GitHub release) ---
log_section "Neovim"
if ! command -v nvim &>/dev/null; then
    log "Installing Neovim..."
    NVIM_VERSION="v0.10.3"
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz" -o /tmp/nvim.tar.gz
    sudo tar xzf /tmp/nvim.tar.gz -C /opt/
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm /tmp/nvim.tar.gz
else
    log "Neovim already installed: $(nvim --version | head -1)"
fi

# --- eza (modern ls) ---
log_section "eza"
if ! command -v eza &>/dev/null; then
    log "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq eza 2>&1 | tail -1
else
    log "eza already installed"
fi

# --- lazygit ---
log_section "lazygit"
if ! command -v lazygit &>/dev/null; then
    log "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
    tar xzf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/lazygit
    rm /tmp/lazygit.tar.gz /tmp/lazygit
else
    log "lazygit already installed"
fi

# --- agent-browser ---
log_section "agent-browser"
if ! command -v agent-browser &>/dev/null; then
    log "Installing agent-browser..."
    npm install -g agent-browser
    npx playwright install --with-deps chromium 2>&1 | tail -1
else
    log "agent-browser already installed: $(agent-browser --version 2>/dev/null || echo 'ok')"
fi

# --- pi-deck ---
log_section "pi-deck"
if ! command -v pi-deck &>/dev/null; then
    log "Installing pi-deck..."
    npm install -g pi-deck
else
    log "pi-deck already installed"
fi

# --- Symlink dotfiles using stow ---
log_section "Symlinking dotfiles"
cd "$DOTFILES_DIR"
# Remove existing files that conflict with stow (workspace may pre-create these)
for f in $(find home -type f -not -name '.gitkeep' | sed 's|^home/||'); do
    if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        log "Removing existing $HOME/$f to allow stow symlink"
        rm -f "$HOME/$f"
    fi
done
# stow treats each top-level dir as a "package" and symlinks its contents into $HOME
stow -v -t "$HOME" home

# --- Ensure .local/bin is available ---
mkdir -p "$HOME/.local/bin"

# --- Source the new shell config ---
log_section "Done!"
log "Dotfiles installed. Restart your shell or run: source ~/.zshrc"
