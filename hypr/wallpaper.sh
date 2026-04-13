#!/bin/bash
# awww wallpaper switcher met pywal voor dynamische kleuren
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

# Genereer pywal kleuren (silent, in background zodat wallpaper meteen wisselt)
wal -i "$NEXT" -n -q &

# Switch wallpaper met awww (smooth fade transition) - gebeurt meteen, wacht niet op pywal
awww img "$NEXT" \
    --transition-type fade \
    --transition-duration 1 \
    --transition-fps 60

# Onthoud keuze
echo "$NEXT" > "$STATE_FILE"

# Wacht tot pywal klaar is
wait

# Update Hyprland border kleuren (live via keyword, geen reload)
if [ -f ~/.cache/wal/colors-hyprland.conf ]; then
    ACTIVE=$(grep 'col.active_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
    INACTIVE=$(grep 'col.inactive_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
    [ -n "$ACTIVE" ] && hyprctl keyword general:col.active_border "$ACTIVE"
    [ -n "$INACTIVE" ] && hyprctl keyword general:col.inactive_border "$INACTIVE"
fi

exit 0
