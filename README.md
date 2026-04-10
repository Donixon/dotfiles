# dotfiles

Persoonlijke Arch Linux configuratie voor een Hyprland desktop.

## Stack

| Component | Tool |
|-----------|------|
| Window manager | Hyprland |
| Status bar | Waybar |
| Terminal | Kitty |
| Launcher | Rofi |
| Lock screen | Hyprlock |
| Idle manager | Hypridle |
| Wallpaper | Hyprpaper + pywal |
| Bestandsbeheer | Nemo |
| Shell | Pure Zsh |
| Display manager | Ly |

## Installatie op een nieuwe laptop

### 1. Arch installeren

Installeer Arch Linux via `archinstall`. Zorg dat je:
- Een gebruiker aangemaakt hebt met sudo rechten
- Internetverbinding hebt
- Als gewone gebruiker bent ingelogd (niet root)

### 2. Script uitvoeren

```bash
bash <(curl -sL https://dot.nezor.nl)
```

Het script draait volledig automatisch en slaat stappen over die al gedaan zijn:

- Pacman optimaliseren (parallel downloads, kleur)
- `yay` installeren (AUR helper)
- Alle packages installeren (inclusief fonts, bluetooth, docker)
- Zsh instellen als standaard shell
- Dotfiles clonen naar `~/.config` via HTTPS
- Symlinks aanmaken (`.zshrc`)
- Nemo acties installeren
- Pywal kleuren genereren
- Locale instellen (en_US + nl_NL)
- Zram instellen (voorkomt vastlopen bij vol geheugen)
- Ly display manager configureren (autologin)
- Alle services aanzetten
- Font cache verversen

### 3. Na afloop

- Herstart je systeem
- Log in via `ly`
- Hyprland start op met al je configuratie
- Bij eerste login stelt `first-login.sh` automatisch eenmalig in: GTK dark mode, Nemo instellingen, Firefox als standaard browser

### 4. Monitornamen aanpassen

Op een nieuwe machine kloppen de monitornamen vrijwel zeker niet. Check ze met:

```bash
hyprctl monitors
```

Pas daarna aan in:
- `hypr/hyprland.conf` — `monitor=` regels bovenaan
- `hypr/hyprpaper.conf` — `monitor =` in het wallpaper blok

## Shortcuts

`$mainMod` = Super (Windows-toets)

### Algemeen

| Shortcut | Actie |
|----------|-------|
| `Super + Enter` | Terminal (Kitty) |
| `Super + Q` | Venster sluiten |
| `Super + Space` | Launcher (Rofi) |
| `Super + E` | Bestandsbeheer (Nemo) |
| `Super + L` | Scherm vergrendelen |
| `Super + M` | Hyprland afsluiten |
| `Super + V` | Klembord history |
| `Ctrl + Shift + Esc` | Power menu |

### Vensters

| Shortcut | Actie |
|----------|-------|
| `Super + pijltjes` | Focus verplaatsen |
| `Super + LMB slepen` | Venster verplaatsen |
| `Super + RMB slepen` | Venster resizen |
| `Super + J` | Split omdraaien |

### Workspaces

| Shortcut | Actie |
|----------|-------|
| `Super + 1-9` | Naar workspace |
| `Super + Shift + 1-9` | Venster naar workspace (stil) |
| `Super + Scroll` | Door workspaces scrollen |

### Screenshots

| Shortcut | Actie |
|----------|-------|
| `Print` | Scherm (monitor) |
| `Super + Print` | Venster |
| `Super + Shift + Print` | Selectie (opgeslagen in ~/screenshots) |

### Wallpaper & media

| Shortcut | Actie |
|----------|-------|
| `Super + Shift + N` | Volgend wallpaper (sequentieel, pywal herlaadt mee) |
| `Super + Shift + P/O/T/U` | Chromium PWA's starten |
| Mediaknoppen | Volume, helderheid, muziek |

## Waybar scripts

Alle scripts staan in `waybar/scripts/`:

| Script | Functie |
|--------|---------|
| `check_updates.sh` | Toont aantal beschikbare updates (pacman + AUR) |
| `update_system.sh` | Voert systeem update uit in terminal |
| `vpn_status.sh` | Toont VPN staat, toggle OpenVPN verbinding |
| `power-menu.sh` | Rofi power menu (vergrendelen/uitloggen/suspend/reboot/uitzetten) |
| `openweathermap.sh` | Haalt weerdata op via OpenWeatherMap API |
| `cava.sh` | Stuurt cava audio visualizer output naar waybar |

## Wijzigingen pushen

```bash
cd ~/.config
git add .
git commit -m "beschrijving"
git push
```

## Configuratie herladen

| Component | Commando |
|-----------|----------|
| Hyprland | `hyprctl reload` |
| Waybar | `pkill waybar && waybar &` |
| Hyprpaper | `pkill hyprpaper && hyprpaper &` |
| Hypridle | `pkill hypridle && hypridle &` |
| Hyprlock | Wordt actief bij volgende vergrendeling (`Super+L`) |
| Kitty | Nieuwe vensters pakken wijzigingen automatisch op |
