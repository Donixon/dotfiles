#!/bin/bash
# lid-dpms.sh — zet schermen aan maar respecteer lid-status
LID_STATE=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | awk '{print $2}')

# Altijd externe monitor aan
hyprctl dispatch dpms on DP-4

if [ "$LID_STATE" = "open" ]; then
    hyprctl keyword monitor "eDP-1, preferred, 0x1200, 1"
else
    hyprctl keyword monitor "eDP-1, disable"
fi
