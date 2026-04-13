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

# Switch wallpaper met awww (instant met smooth fade)
awww img "$NEXT" \
    --transition-type fade \
    --transition-duration 1 \
    --transition-fps 60 &

# Genereer pywal kleuren in background (non-blocking)
(
    wal -i "$NEXT" -n -q
    
    # Update Hyprland border kleuren
    if [ -f ~/.cache/wal/colors-hyprland.conf ]; then
        ACTIVE=$(grep 'col.active_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
        INACTIVE=$(grep 'col.inactive_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
        [ -n "$ACTIVE" ] && hyprctl keyword general:col.active_border "$ACTIVE"
        [ -n "$INACTIVE" ] && hyprctl keyword general:col.inactive_border "$INACTIVE"
    fi
    
    # Waybar reload verwijderd - veroorzaakt monitor/lid-dpms issues
) &

# Onthoud keuze (instant feedback)
echo "$NEXT" > "$STATE_FILE"

exit 0
