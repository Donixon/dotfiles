#!/bin/bash

# Workspace 2: Outlook en Planner (op achtergrond starten)
hyprctl dispatch exec "[workspace 2 silent] chromium --app-id=faolnafnngnfdaknnbpnkhgohbobgegn"
sleep 1
hyprctl dispatch exec "[workspace 2 silent] chromium --app-id=noeelpholkgjlnfojocdmeoegbphfdnpbn"

# Workspace 1: volgorde is belangrijk voor dwindle layout
# Discord eerst (vult scherm), dan Firefox (splits 75% rechts), dan Teams (splits 33% van Firefox)
sleep 1
hyprctl dispatch exec "[workspace 1 silent] discord"
sleep 3
hyprctl dispatch exec "[workspace 1 silent] firefox"
sleep 2
hyprctl dispatch exec "[workspace 1 silent] chromium --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo"
