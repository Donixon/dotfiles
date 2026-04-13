#!/bin/bash
# Reload waybar met nieuwe pywal kleuren (safe restart)

# Check of waybar draait
if ! pgrep -x waybar > /dev/null; then
    waybar &
    exit 0
fi

# Wacht tot pywal klaar is
if [ ! -f ~/.cache/wal/colors-waybar.css ]; then
    sleep 0.3
fi

# Graceful restart
pkill -SIGTERM waybar
sleep 0.3

# Start waybar opnieuw
waybar &
