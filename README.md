# Homebrew Tap for Upkeep

This is a [Homebrew](https://brew.sh/) tap for [Upkeep](https://github.com/zenone/upkeep) - a modern, safe-by-default maintenance toolkit for macOS.

## Installation

```bash
# Add the tap
brew tap zenone/tap https://github.com/zenone/homebrew-tap

# Install upkeep
brew install upkeep
```

Or in one line:

```bash
brew install zenone/tap/upkeep
```

## Usage

After installation, you have three commands available:

```bash
# Launch the web dashboard
upkeep-web

# Quick system health check (bash script)
upkeep-sh --status

# Run safe maintenance operations
upkeep-sh --all-safe

# Python CLI for system info
upkeep --help
```

## Updating

```bash
brew update
brew upgrade upkeep
```

## Uninstalling

```bash
brew uninstall upkeep
brew untap zenone/tap
```

## About Upkeep

Upkeep is your Mac's personal health coach - a comprehensive maintenance toolkit that takes a measured, informed approach to system optimization. Unlike "cleaner" apps that use scare tactics, Upkeep shows you actual data and lets you make informed decisions.

**Features:**
- 🩺 Quick Health Check - Comprehensive system scan
- 📊 44 maintenance operations (updates, cleanup, reports)
- 📅 Scheduled maintenance via macOS launchd
- 🗑️ App Uninstaller with associated data cleanup
- 📁 Disk visualization and duplicate finder
- 🌙 Dark mode support

For more information, visit the [Upkeep repository](https://github.com/zenone/upkeep).
