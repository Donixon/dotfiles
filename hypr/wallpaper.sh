#!/bin/bash
# wallpaper.sh — switch wallpaper and regenerate pywal colors
# Usage: wallpaper.sh [path]   → set specific wallpaper
#        wallpaper.sh          → pick a random one from wallpapers dir

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

if [ -n "$1" ]; then
    WALLPAPER="$1"
else
    CURRENT=$(grep "path = " ~/.config/hypr/hyprpaper.conf 2>/dev/null | awk '{print $3}')
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | grep -v "$CURRENT" | shuf -n 1)
    # Fallback als er maar één wallpaper is
    [ -z "$WALLPAPER" ] && WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
fi

if [ ! -f "$WALLPAPER" ]; then
    echo "Wallpaper not found: $WALLPAPER"
    exit 1
fi

echo "Setting wallpaper: $WALLPAPER"

# Generate pywal colors
wal -i "$WALLPAPER" -n -q

# Stel wallpaper in via hyprpaper
cat > ~/.config/hypr/hyprpaper.conf << EOF
splash = false

wallpaper {
    monitor = DP-4
    path = $WALLPAPER
    fit_mode = cover
}
EOF
pkill hyprpaper; sleep 0.3 && hyprpaper &

# Pas Hyprland border kleuren aan via keyword (geen full reload — dat zet eDP-1 aan)
ACTIVE=$(grep 'active_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
INACTIVE=$(grep 'inactive_border' ~/.cache/wal/colors-hyprland.conf | sed 's/.*= //')
[ -n "$ACTIVE" ]   && hyprctl keyword general:col.active_border "$ACTIVE"
[ -n "$INACTIVE" ] && hyprctl keyword general:col.inactive_border "$INACTIVE"

# Reload Waybar (CSS kleuren)
pkill waybar; sleep 0.3 && waybar &

# Herstel monitor staat (lid dicht = eDP-1 uit)
sleep 0.5
~/.config/hypr/lid-dpms.sh

echo "Done."
