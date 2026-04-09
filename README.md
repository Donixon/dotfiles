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
| Wallpaper | Hyprpaper |
| Bestandsbeheer | Nemo |
| Shell | Pure Zsh |

## Installatie op een nieuwe laptop

### 1. Arch installeren

Installeer Arch Linux via de officiële installatiegids. Zorg dat je:
- Een gebruiker hebt aangemaakt
- Internetverbinding hebt
- Als gewone gebruiker bent ingelogd (niet root)

### 2. Script uitvoeren

```bash
bash <(curl -s https://raw.githubusercontent.com/Donixon/dotfiles/main/install.sh)
```

Het script doet automatisch:
- `yay` installeren (AUR helper)
- Alle packages installeren
- Zsh instellen als standaard shell (geen framework)
- SSH key aanmaken en GitHub koppelen
- Dotfiles clonen naar `~/.config`
- GTK dark mode instellen
- Nemo instellingen toepassen
- Alle services aanzetten

Het script vraagt halverwege om je SSH key toe te voegen aan GitHub.

### 3. Na afloop

- Herstart je systeem
- Log in via `ly`
- Hyprland start op met al je configuratie

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
| `Super + Shift + 1-9` | Venster naar workspace |
| `Super + Scroll` | Door workspaces scrollen |

### Screenshots

| Shortcut | Actie |
|----------|-------|
| `Print` | Scherm (monitor) |
| `Super + Print` | Venster |
| `Super + Shift + Print` | Selectie (opgeslagen in ~/screenshots) |

### Media & overig

| Shortcut | Actie |
|----------|-------|
| `Super + Shift + N` | Willekeurig wallpaper |
| `Super + Shift + P/O/T/U` | Chromium PWA's starten |
| Mediaknoppen | Volume, helderheid, muziek |

## Wijzigingen pushen

```bash
cd ~/.config
git add .
git commit -m "beschrijving"
git push
```
