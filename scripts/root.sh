#!/usr/bin/env bash
set -e

# System packages
apt-get update -qq
apt-get install -y -qq curl git build-essential procps file tmux

# Skill dependencies (apt)
# jq: session-logs, trello | ripgrep: session-logs
apt-get install -y -qq jq ripgrep

# Fix npm permissions
chown -R node:node /usr/local/lib/node_modules /usr/local/bin /usr/local/share /usr/local/lib /usr/local/include 2>/dev/null || true
chown -R node:node /home/node

# Configure npm/pnpm paths
bash -c 'cat >> /home/node/.bashrc << "EOF"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$NPM_CONFIG_PREFIX/bin:$PNPM_HOME:$PATH"
EOF'

# Prepare Homebrew
mkdir -p /home/linuxbrew/.linuxbrew
chown -R node:node /home/linuxbrew/.linuxbrew
mkdir -p /home/node/.cache/Homebrew
chown -R node:node /home/node/.cache
bash -c 'echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> /home/node/.bashrc'

# Install Go
curl -fsSL https://go.dev/dl/go1.23.6.linux-amd64.tar.gz | tar -C /usr/local -xz
bash -c 'cat >> /home/node/.bashrc << "EOF"
export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
EOF'

# Prepare uv
bash -c 'echo "source \"\$HOME/.local/bin/env\"" >> /home/node/.bashrc'

# Finalize permissions
chown -R node:node /home/node
chown node:node /home/node/.bashrc

# Root setup complete
