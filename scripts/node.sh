#!/bin/bash
set -e

# ─── npm/pnpm ────────────────────────────────────────────────
# npm globals install to /usr/local (permissions fixed in root.sh)

# Global npm packages
npm i -g @steipete/summarize       # summarize skill
npm i -g clawhub                   # clawhub skill
npm i -g mcporter                  # mcporter skill
npm i -g @steipete/oracle          # oracle skill
npm i -g @xdevplatform/xurl        # xurl skill

# ─── Homebrew ─────────────────────────────────────────────────
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Skill dependencies (Homebrew)
brew tap steipete/tap 2>&1
brew install 1password-cli 2>&1                   # 1password skill (bin: op)
brew install gemini-cli 2>&1                      # gemini skill
brew install gh 2>&1                              # github, gh-issues skills
brew install himalaya 2>&1                        # himalaya skill
brew install steipete/tap/gifgrep 2>&1            # gifgrep skill
brew install steipete/tap/gogcli 2>&1             # gog skill
brew install steipete/tap/goplaces 2>&1           # goplaces skill
brew install steipete/tap/ordercli 2>&1           # ordercli skill
brew install steipete/tap/sag 2>&1                # sag skill
brew install steipete/tap/songsee 2>&1            # songsee skill
brew install steipete/tap/spogo 2>&1              # spotify-player skill
brew install yakitrak/yakitrak/obsidian-cli 2>&1  # obsidian skill
brew install openhue/cli/openhue-cli 2>&1         # openhue skill
brew install ffmpeg 2>&1                          # video-frames, songsee skills
# NOTE: openai-whisper skipped (very large — pulls full Python + ML models)
# NOTE: sherpa-onnx-tts skipped (requires manual runtime/model download)

# ─── Go ───────────────────────────────────────────────────────
export GOPATH="/opt/tools/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

# Skill dependencies (Go)
go install github.com/Hyaxia/blogwatcher/cmd/blogwatcher@latest   # blogwatcher skill
go install github.com/steipete/blucli/cmd/blu@latest              # blucli skill
go install github.com/steipete/eightctl/cmd/eightctl@latest       # eightctl skill
go install github.com/steipete/sonoscli/cmd/sonos@latest          # sonoscli skill
go install github.com/steipete/wacli/cmd/wacli@latest             # wacli skill

# ─── uv (Python) ─────────────────────────────────────────────
export UV_INSTALL_DIR="/opt/tools/uv/bin"
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="/opt/tools/uv/bin:$PATH"

# Skill dependencies (uv/Python)
# Install tools to /opt/tools so they survive /home/node volume mounts
export UV_TOOL_BIN_DIR="/opt/tools/uv/bin"
export UV_TOOL_DIR="/opt/tools/uv/tools"
uv tool install nano-pdf                     # nano-pdf skill

# ─── Cleanup caches ──────────────────────────────────────────
# npm
npm cache clean --force 2>/dev/null || true
rm -rf /home/node/.npm/_cacache

# Homebrew (keeps taps & installed formulae, removes downloads)
brew cleanup --prune=all -s 2>/dev/null || true
rm -rf "$(brew --cache)" 2>/dev/null || true
rm -rf /home/linuxbrew/.linuxbrew/Library/Taps/homebrew/homebrew-core/.git

# Go (keep compiled binaries, remove build & module cache)
go clean -cache -modcache -fuzzcache 2>/dev/null || true

# uv / pip
rm -rf /home/node/.cache/uv /home/node/.cache/pip

# Temp files
rm -rf /tmp/* /var/tmp/*

# Node setup complete
# All skill dependencies installed and labeled above
#
# macOS-only skills (not available in Docker/Linux):
#   apple-notes, apple-reminders, bear-notes, camsnap, imsg,
#   model-usage, peekaboo, things-mac
#
# Config/API-only skills (no binary install needed):
#   bluebubbles, canvas, coding-agent, discord, healthcheck,
#   nano-banana-pro, notion, openai-image-gen, openai-whisper-api,
#   skill-creator, slack, voice-call, weather
#
# Already covered by base packages (root.sh):
#   tmux skill (tmux), weather skill (curl), session-logs + trello (jq, ripgrep)
