# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Linux desktop configuration directory (`~/.config`) for an Arch Linux system running Hyprland (Wayland compositor). There is no build system — changes take effect by reloading the relevant application.

## Applying Changes

| Component | Reload command |
|-----------|---------------|
| Hyprland | `hyprctl reload` |
| Waybar | `pkill waybar && waybar &` |
| Hyprpaper | `pkill hyprpaper && hyprpaper &` |
| Hypridle | `pkill hypridle && hypridle &` |
| Hyprlock | Takes effect on next lock (`Super+L`) |
| Kitty | New windows pick up changes automatically |

## Desktop Stack

- **Window manager:** Hyprland — `hypr/hyprland.conf` (single file, all keybindings and rules)
- **Status bar:** Waybar — layout in `waybar/config.jsonc`, module definitions in `waybar/modules.jsonc`, styling in `waybar/style.css`
- **Terminal:** Kitty — `kitty/kitty.conf`
- **Launcher:** Rofi (`Super+Space`)
- **Lock screen:** Hyprlock — `hypr/hyprlock.conf`
- **Idle manager:** Hypridle — `hypr/hypridle.conf`
- **Wallpaper:** Hyprpaper — `hypr/hyprpaper.conf`

## Key Hyprland Bindings

- `$mainMod` = Super (Windows key)
- `Super+Return` → terminal (kitty), `Super+Q` → close window, `Super+Space` → rofi
- `Super+L` → lock screen, `Super+M` → exit Hyprland
- `Super+[1-9]` → switch workspace, `Super+Shift+[1-9]` → move window to workspace
- `Super+Shift+P/O/T/U` → launch Chromium PWAs (planner/Outlook/Teams/3CX)

## Monitor Setup

Three-monitor configuration:
- `eDP-1` — laptop display (auto-disabled when lid closed)
- `DVI-I-2` — 1920×1080 at position 0,0 (primary external)
- `DVI-I-1` — 1920×1080 at position -1920,0 (left external)

## Waybar Scripts

All scripts live in `waybar/scripts/`:
- `check_updates.sh` — queries pacman + AUR for pending updates (used by `custom/updates` module)
- `update_system.sh` — runs system update in a terminal window
- `vpn_status.sh` — shows VPN state and toggles OpenVPN connection
- `power-menu.sh` — rofi-based power menu (lock/logout/suspend/reboot/shutdown)
- `openweathermap.sh` — fetches weather data via OpenWeatherMap API
- `cava.sh` — pipes cava audio visualizer output to waybar

## Input

- Keyboard layout: `us` with `intl` variant (for international characters via dead keys)
- Touchpad: natural scroll enabled
- Window manager layout: dwindle (binary space partitioning)
