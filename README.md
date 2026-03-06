# openclaw_docker

Openclaw Docker Image with pre-configured environment, development tools, and
built-in skill dependencies.

## Build

### Local

```bash
docker build -t openclaw:custom .
```

### Automated (GitHub Actions)

A GitHub Actions workflow (`.github/workflows/build.yml`) automatically rebuilds
the image:

- **Daily** at 04:00 UTC — checks if the OpenClaw base image has a new digest
- **On push** to `main` — always rebuilds
- **Manual** — via `workflow_dispatch` in the Actions tab

The built image is pushed to `ghcr.io/<owner>/openclaw_docker:latest`. Scheduled
runs are skipped if the base image hasn't changed since the last build.

## Additional Configuration

The image automatically runs two setup scripts:

### Root-Setup (`scripts/root.sh`)

- **System Packages**: curl, git, build-essential, procps, file, tmux
- **Skill APT Packages**: jq (session-logs, trello), ripgrep (session-logs)
- **npm/pnpm Permissions**: Directories configured for node user
- **npm/pnpm Paths**: `~/.npm-global` and `~/.local/share/pnpm` added to PATH
- **Homebrew**: Prepared under `/home/linuxbrew/.linuxbrew`
- **Go**: Version 1.23.6 installed under `/usr/local/go`
- **uv**: Python Package Manager prepared
- **Bashrc**: All paths automatically added to `~/.bashrc`

### Node-Setup (`scripts/node.sh`)

- **npm packages**: @steipete/summarize, clawhub, mcporter, @steipete/oracle,
  @xdevplatform/xurl
- **Homebrew**: Fully installed as node user
- **Brew packages**: 1password-cli, ffmpeg, gemini-cli, gh, himalaya, gifgrep,
  gogcli, goplaces, ordercli, sag, songsee, spogo, obsidian-cli, openhue-cli
- **Go workspace**: Prepared under `~/go`
- **Go packages**: blogwatcher, blu (blucli), eightctl, sonos (sonoscli), wacli
- **uv**: Python UV installer executed
- **uv packages**: nano-pdf

## Skill Dependency Overview

| Skill              | Install Method | Binary / Package                |
| ------------------ | -------------- | ------------------------------- |
| 1password          | brew           | `op` (1password-cli)            |
| blogwatcher        | go             | `blogwatcher`                   |
| blucli             | go             | `blu`                           |
| clawhub            | npm            | `clawhub`                       |
| eightctl           | go             | `eightctl`                      |
| gemini             | brew           | `gemini` (gemini-cli)           |
| gh-issues / github | brew           | `gh`                            |
| gifgrep            | brew           | `gifgrep`                       |
| gog                | brew           | `gog` (gogcli)                  |
| goplaces           | brew           | `goplaces`                      |
| himalaya           | brew           | `himalaya`                      |
| mcporter           | npm            | `mcporter`                      |
| nano-pdf           | uv             | `nano-pdf`                      |
| obsidian           | brew           | `obsidian-cli`                  |
| openhue            | brew           | `openhue` (openhue-cli)         |
| oracle             | npm            | `oracle`                        |
| ordercli           | brew           | `ordercli`                      |
| sag                | brew           | `sag`                           |
| session-logs       | apt            | `jq`, `rg` (ripgrep)            |
| songsee            | brew           | `songsee`                       |
| sonoscli           | go             | `sonos`                         |
| spotify-player     | brew           | `spogo`                         |
| summarize          | npm            | `summarize`                     |
| tmux               | apt            | `tmux` (base packages)          |
| trello             | apt            | `jq` (shared with session-logs) |
| video-frames       | brew           | `ffmpeg`                        |
| wacli              | go             | `wacli`                         |
| weather            | apt            | `curl` (base packages)          |
| xurl               | npm            | `xurl`                          |

### Skipped Skills

**macOS-only** (not available in Linux Docker): apple-notes, apple-reminders,
bear-notes, camsnap, imsg, model-usage, peekaboo, things-mac

**Config/API-only** (no binary install needed): bluebubbles, canvas,
coding-agent, discord, healthcheck, nano-banana-pro, notion, openai-image-gen,
openai-whisper-api, skill-creator, slack, voice-call

**Manually skipped** (too large or requires manual setup): openai-whisper (very
large ML package), sherpa-onnx-tts (requires manual runtime/model download)

## Included Tools

- npm, pnpm (Node Package Manager)
- Homebrew (Linux)
- Go 1.23.6
- uv (Python Package Manager)
- Git, curl, build-essential and other development tools

## Usage

```bash
docker run -it openclaw:custom bash
```

All tools are immediately available and environment variables are
pre-configured.

## Volume Persistence

Tool configurations and auth tokens are lost when the container is removed.
Mount the following paths as Docker volumes to persist them across runs.

All paths are relative to the `node` home (`/home/node`).

| Path                       | Tool                   | Content                                           |
| -------------------------- | ---------------------- | ------------------------------------------------- |
| `~/.openclaw`              | OpenClaw               | Main config, agents, session logs, skill settings |
| `~/.config/gh`             | GitHub CLI (`gh`)      | Auth tokens, config, hosts                        |
| `~/.config/gogcli`         | gogcli (`gog`)         | Config, keyring (Google OAuth tokens)             |
| `~/.config/himalaya`       | Himalaya               | Email account config (`config.toml`)              |
| `~/.config/eightctl`       | eightctl               | Eight Sleep config & credentials (`config.yaml`)  |
| `~/.config/spotify-player` | spogo / spotify_player | Spotify config (`app.toml`), auth cache           |
| `~/.config/op`             | 1Password CLI (`op`)   | Session tokens, config                            |
| `~/.config/ordercli`       | ordercli               | Foodora/Deliveroo config & session tokens         |
| `~/.gemini`                | Gemini CLI             | Settings (`settings.json`), auth state            |
| `~/.wacli`                 | wacli                  | WhatsApp session store                            |
| `~/.xurl`                  | xurl                   | X/Twitter OAuth tokens (YAML)                     |
| `~/.summarize`             | summarize              | Config (`config.json`)                            |
