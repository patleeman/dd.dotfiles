# dd.dotfiles

Personal workspace dotfiles for Datadog cloud development environments.

## What's Included

### Tools installed by `install.sh`
- **Oh My Zsh** — zsh framework with plugins (git, fzf, vi-mode)
- **Neovim** — latest stable from GitHub releases
- **eza** — modern `ls` replacement
- **lazygit** — terminal git UI
- **fzf, ripgrep, fd** — fast fuzzy finding and search
- **tmux, htop, tree, jq** — essentials

### Configs (symlinked via stow)
- `.zshrc` — zsh config with Datadog paths, aliases, vi-mode
- `.gitconfig` — git aliases, sane defaults (no macOS-specific signing)
- `.tmux.conf` — tmux with Ctrl-A prefix, vim-style nav, OSC52 clipboard
- `.config/nvim/` — Neovim config with lazy.nvim, telescope, treesitter

### Helper scripts (`bin/`)
- `ws-info` — print workspace disk, memory, key paths
- `ws-port-forward` — instructions for accessing workspace ports

## Usage

### First time: Set up workspace config on your laptop

```bash
mkdir -p ~/.config/datadog/workspaces
cat > ~/.config/datadog/workspaces/config.yaml << 'EOF'
shell: zsh
region: us-east-1
dotfiles: https://github.com/patleeman/dd.dotfiles
editor: cursor
EOF
```

### Create a workspace

```bash
workspaces create patrick-lee --repo dd-source
```

The dotfiles are automatically cloned and `install.sh` runs during creation.

### Manual setup (existing workspace)

```bash
cd ~/dotfiles
./install.sh
source ~/.zshrc
```

### Secrets (set on laptop before workspace creation)

```bash
workspaces secrets set GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w) --export
workspaces secrets set ANTHROPIC_APIKEY1=<your-key>
```

### Local overrides

Create `~/.zshrc.local` on the workspace for machine-specific settings
that shouldn't be in git (e.g., tokens, experiment flags).

## Structure

```
dd.dotfiles/
├── install.sh              # Runs on workspace creation (installs tools + stow)
├── home/                   # Stowed into $HOME
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .tmux.conf
│   ├── .config/
│   │   └── nvim/
│   │       ├── init.lua
│   │       └── lazy-lock.json
│   └── .local/
│       └── bin/            # (empty, created by install.sh)
├── bin/                    # Added to PATH via .zshrc
│   ├── ws-info
│   └── ws-port-forward
└── README.md
```
