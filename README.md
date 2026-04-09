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
| Shell | Zsh (geen framework) |

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

Het script installeert automatisch:
- `yay` (AUR helper)
- Alle pacman en AUR packages
- Zsh config (via symlink)
- Oh My Zsh wordt **niet** gebruikt
- SSH key aanmaken + GitHub koppelen
- Dotfiles clonen naar `~/.config`
- GTK dark mode instellen
- Nemo instellingen
- Alle benodigde services aanzetten

Halverwege vraagt het script om je SSH key toe te voegen aan GitHub en om je OpenWeatherMap API key in te vullen.

### 3. Na afloop

- Herstart je systeem
- Log in via `ly`
- Hyprland start op met al je configuratie

## Gevoelige bestanden

`waybar/scripts/secrets.env` staat niet in de repo. Het install script vraagt hierom, maar je kunt het ook handmatig aanmaken:

```bash
echo 'API_KEY="jouw_key_hier"' > ~/.config/waybar/scripts/secrets.env
```

Haal je OpenWeatherMap API key op via [openweathermap.org](https://openweathermap.org/api).

## Wijzigingen pushen

```bash
cd ~/.config
git add .
git commit -m "beschrijving"
git push
```
