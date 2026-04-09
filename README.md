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

## Wijzigingen pushen

```bash
cd ~/.config
git add .
git commit -m "beschrijving"
git push
```
