#!/usr/bin/env bash
set -e

# ─── npm/pnpm ────────────────────────────────────────────────
mkdir -p /home/node/.npm-global /home/node/.local/share/pnpm
npm config set prefix /home/node/.npm-global

# Global npm packages
npm i -g @steipete/summarize       # summarize skill
npm i -g clawhub                   # clawhub skill
npm i -g mcporter                  # mcporter skill
npm i -g @steipete/oracle          # oracle skill
npm i -g @xdevplatform/xurl        # xurl skill
ln -s /home/node/.npm-global/bin/summarize /usr/local/bin/summarize

# ─── Homebrew ─────────────────────────────────────────────────
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Skill dependencies (Homebrew)
brew tap steipete/tap
brew install 1password-cli                   # 1password skill (bin: op)
brew install gemini-cli                      # gemini skill
brew install gh                              # github, gh-issues skills
brew install himalaya                        # himalaya skill
brew install steipete/tap/gifgrep            # gifgrep skill
brew install steipete/tap/gogcli             # gog skill
brew install steipete/tap/goplaces           # goplaces skill
brew install steipete/tap/ordercli           # ordercli skill
brew install steipete/tap/sag                # sag skill
brew install steipete/tap/songsee            # songsee skill
brew install steipete/tap/spogo              # spotify-player skill
brew install yakitrak/yakitrak/obsidian-cli  # obsidian skill
brew install openhue/cli/openhue-cli         # openhue skill
brew install ffmpeg                          # video-frames, songsee skills
# NOTE: openai-whisper skipped (very large — pulls full Python + ML models)
# NOTE: sherpa-onnx-tts skipped (requires manual runtime/model download)

# ─── Go ───────────────────────────────────────────────────────
mkdir -p /home/node/go
export GOPATH="/home/node/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

# Skill dependencies (Go)
go install github.com/Hyaxia/blogwatcher/cmd/blogwatcher@latest   # blogwatcher skill
go install github.com/steipete/blucli/cmd/blu@latest              # blucli skill
go install github.com/steipete/eightctl/cmd/eightctl@latest       # eightctl skill
go install github.com/steipete/sonoscli/cmd/sonos@latest          # sonoscli skill
go install github.com/steipete/wacli/cmd/wacli@latest             # wacli skill

# ─── uv (Python) ─────────────────────────────────────────────
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Skill dependencies (uv/Python)
uv tool install nano-pdf                     # nano-pdf skill

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
