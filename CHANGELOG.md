# Changelog

Every Marmot release, newest first. Downloads are on [GitHub Releases](https://github.com/Kasakir-AI/Marmot/releases).

## Unreleased

- The signed release can ask for Automation permission again. Startup shows your login items, and moving
  a file to the Trash through Finder works when the direct way fails. 1.0.2 was signed without the setting that
  lets it send these requests, so the login item list came up empty.

## 1.0.2 (2026-11-21)

- Marmot is signed with Developer ID and notarized by Apple. The new disk image opens through the normal macOS security checks.

## 1.0.1 (2026-11-18)

A safety fix for the protection that keeps your important files out of every cleanup.

- **Protected folders stay protected, however a path is written.** Marmot checks every item again right before removing it, and never touches areas like your device backups, Documents, Photos, Mail or keychains. A path written with an extra "." in it (for example `Application Support/./MobileSync`) could slip past that last check even though it points into a protected folder. Marmot now refuses such paths outright.
- Nothing else changes in how you use Marmot. Your settings, History and Autopilot rules are kept.

## 1.0.0 (2026-11-14)

Marmot 1.0.0 is a fresh start for the free, open-source Mac cleaner that shows you everything before it changes anything. It's the same app, with a new version number and a clean release history.

- **Clean:** Cleanup, Autopilot, Duplicates and Big Files free up space. Every change is a plan you review first, with a dry run, and removals go to the Trash so you can restore them from History.
- **Apps:** the Uninstaller removes apps along with their leftovers, with Reset and Time Capsule. Unused Apps and App Updates help with the rest.
- **System:** Disk Map, Startup Items, Maintenance, Live Status and the menu bar monitor show what's happening on your Mac.
- **Already using Marmot?** This update installs over your current version and keeps your settings, History and Autopilot rules.
- **Homebrew:** install with `brew install --cask kasakir-ai/tap/marmot`. If you installed from the old `kasakir-ai/marmot` tap, follow the one-time steps in the [tap's README](https://github.com/Kasakir-AI/homebrew-tap#moving-from-the-old-marmot-tap).
- Requires macOS 26 (Tahoe) or later.
