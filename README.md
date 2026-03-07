# OpenClaw Docker (Full-Featured)

Custom OpenClaw Docker image with pre-installed package managers and a
one-command skill installer.

## Image

```
ghcr.io/hudint/openclaw_docker_full_featured:latest
```

## Build

```bash
docker build -t openclaw:custom .
```

## What's included

### Pre-installed (in the image)

- **System packages** (apt): curl, git, build-essential, procps, file, tmux, jq,
  ripgrep
- **Go** 1.23.6 toolchain (`/usr/local/go`)
- **Homebrew** (`/home/linuxbrew/.linuxbrew`)
- **uv** Python package manager (`~/.local/bin`)
- **npm, pnpm, Bun** (from base image)

### install-skills (run once)

The `install-skills` command installs all skill dependencies into `/home/node/`.
When using a volume mount on `/home/node`, you only need to run it once —
everything persists.

| Category | Packages                                                                                                                             |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| npm      | @steipete/summarize, clawhub, mcporter, @steipete/oracle, @xdevplatform/xurl                                                         |
| Homebrew | 1password-cli, gemini-cli, gh, himalaya, gifgrep, gogcli, goplaces, ordercli, sag, songsee, spogo, obsidian-cli, openhue-cli, ffmpeg |
| Go       | blogwatcher, blu (blucli), eightctl, sonos (sonoscli), wacli                                                                         |
| uv       | nano-pdf                                                                                                                             |

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

- npm, pnpm, Bun (from base image)
- Homebrew (Linux)
- Go 1.23.6
- uv (Python package manager)
- Git, curl, build-essential, tmux, jq, ripgrep

## Volume Persistence

Mount two volumes so all installed tools and configs persist across container
restarts:

- `/home/node` — npm, Go, uv packages + all tool configs
- `/home/linuxbrew/.linuxbrew` — Homebrew and all brew-installed packages

> **Note:** `/home/linuxbrew/.linuxbrew` must be a **named volume**. Docker
> automatically copies the Homebrew installation from the image into a new named
> volume on first start. With a bind mount the directory would be empty and
> Homebrew would be missing. For `/home/node` both named volumes and bind mounts
> work fine.

```yaml
volumes:
    - openclaw-home:/home/node
    - openclaw-brew:/home/linuxbrew/.linuxbrew
```

Config paths reference:

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

## License

This image is based on [OpenClaw](https://github.com/openclaw/openclaw), which
is licensed under the
[MIT License](https://github.com/openclaw/openclaw/blob/main/LICENSE). The
additional scripts and configuration in this repository are also provided under
the MIT License.
