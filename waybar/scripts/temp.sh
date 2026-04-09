#!/bin/bash
TEMP_FILE="/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon3/temp1_input"
TEMP_RAW=$(cat "$TEMP_FILE")
TEMP=$((TEMP_RAW / 1000))

if [ "$TEMP" -lt 50 ]; then
    ICON="󰔏"
    CLASS="cool"
elif [ "$TEMP" -lt 65 ]; then
    ICON="󰔐"
    CLASS="normal"
elif [ "$TEMP" -lt 75 ]; then
    ICON="󰔑"
    CLASS="warm"
else
    ICON="󰔑"
    CLASS="hot"
fi

echo "{\"text\": \"$ICON ${TEMP}°C\", \"class\": \"$CLASS\", \"tooltip\": \"CPU: ${TEMP}°C\"}"
