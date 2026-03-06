#!/bin/bash
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

# Create /opt/tools for build-time tool installations
# (separate from /home/node so volume mounts don't hide them)
mkdir -p /opt/tools/go /opt/tools/uv
chown -R node:node /opt/tools

# Prepare Homebrew
mkdir -p /home/linuxbrew/.linuxbrew
chown -R node:node /home/linuxbrew/.linuxbrew
mkdir -p /home/node/.cache/Homebrew
chown -R node:node /home/node/.cache

# Install Go
curl -fsSL https://go.dev/dl/go1.23.6.linux-amd64.tar.gz | tar -C /usr/local -xz

# Clean apt cache
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Finalize permissions
chown -R node:node /home/node
chown node:node /home/node/.bashrc

# Root setup complete
