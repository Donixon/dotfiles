#!/bin/bash
# awww wallpaper switcher - snel, simpel, betrouwbaar
# SUPER+SHIFT+N: volgende wallpaper

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
STATE_FILE="$HOME/.config/hypr/.current_wallpaper"

# Start awww daemon als die niet draait
if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

# Haal huidige wallpaper op
CURRENT=$(cat "$STATE_FILE" 2>/dev/null)

# Vind alle wallpapers (gesorteerd)
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Geen wallpapers gevonden in $WALLPAPER_DIR"
    exit 1
fi

# Als argument gegeven, gebruik die
if [ -n "$1" ] && [ -f "$1" ]; then
    NEXT="$1"
else
    # Vind index van huidige wallpaper en ga naar volgende
    NEXT_INDEX=0
    for i in "${!WALLPAPERS[@]}"; do
        if [ "${WALLPAPERS[$i]}" = "$CURRENT" ]; then
            NEXT_INDEX=$(( (i + 1) % ${#WALLPAPERS[@]} ))
            break
        fi
    done
    NEXT="${WALLPAPERS[$NEXT_INDEX]}"
fi

# Switch wallpaper met awww (smooth fade transition)
awww img "$NEXT" \
    --transition-type fade \
    --transition-duration 1 \
    --transition-fps 60

# Onthoud keuze
echo "$NEXT" > "$STATE_FILE"

# Optionele notificatie
BASENAME=$(basename "$NEXT" | sed 's/\.[^.]*$//')
notify-send -t 1500 "Wallpaper" "$BASENAME" 2>/dev/null

exit 0
