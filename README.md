# Homebrew Tap for Upkeep

This is a [Homebrew](https://brew.sh/) tap for [Upkeep](https://github.com/zenone/upkeep) — a modern, safe-by-default maintenance toolkit for macOS.

## Installation

```bash
brew install zenone/tap/upkeep
```

That's it! One command installs everything.

## Available Commands

| Command | What It Does |
|---------|--------------|
| `upkeep-web` | Launch the web dashboard at http://localhost:8080 |
| `upkeep` | Python CLI with rich terminal output |
| `upkeep-sh` | Direct bash script (works without Python) |

## Quick Start

```bash
# Launch the web UI (recommended)
upkeep-web

# Quick health check in terminal
upkeep-sh --status

# Run safe maintenance operations
upkeep-sh --all-safe

# See all options
upkeep-sh --help
```

## Web Dashboard

```bash
upkeep-web
```

- Opens automatically at **http://localhost:8080**
- Runs in foreground — press `Ctrl+C` to stop
- Use a different port: `upkeep-web --port 9000`

## Scheduled Maintenance (Optional)

Want automatic scheduled maintenance? Install the background daemon:

```bash
sudo "$(brew --prefix upkeep)/libexec/install-daemon.sh"
```

Then configure schedules via the web UI's **Schedule** tab.

**Daemon management:**
```bash
# Check status
sudo launchctl list | grep upkeep

# View logs
tail -f /var/log/upkeep-daemon.log

# Stop/start
sudo launchctl unload /Library/LaunchDaemons/com.upkeep.daemon.plist
sudo launchctl load /Library/LaunchDaemons/com.upkeep.daemon.plist
```

## Updating

```bash
brew update && brew upgrade upkeep
```

## Uninstalling

```bash
brew uninstall upkeep
brew untap zenone/tap
```

## About Upkeep

Your Mac's personal health coach — a comprehensive maintenance toolkit that takes a measured, informed approach. Unlike "cleaner" apps that use scare tactics, Upkeep shows you actual data and lets you make informed decisions.

**Features:**
- 🌐 Web dashboard with 7 tabs (Dashboard, Storage, Maintenance, Uninstaller, Disk Viz, Duplicates, Schedule)
- 🩺 Health score with actionable insights
- 📊 44 maintenance operations organized by category
- 📅 Scheduled maintenance via macOS launchd
- 🗑️ App uninstaller with full associated data cleanup
- 📁 Disk visualization and duplicate finder
- 🌙 Dark mode support

For full documentation, visit the [Upkeep repository](https://github.com/zenone/upkeep).

---

<p align="center">
  Made by <a href="https://github.com/zenone">@zenone</a>
  <br>
  <a href="https://www.linkedin.com/in/zenone/">LinkedIn</a> · <a href="https://github.com/zenone">GitHub</a>
</p>
