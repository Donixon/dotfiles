#!/bin/bash
# Eenmalige setup na eerste Hyprland login.
# Wordt automatisch aangeroepen via exec-once in hyprland.conf.

MARKER="$HOME/.config/.first-login-done"
[ -f "$MARKER" ] && exit 0

# GTK dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Nemo instellingen
dconf write /org/nemo/preferences/default-folder-viewer "'list-view'"
dconf write /org/nemo/preferences/show-hidden-files false
dconf write /org/nemo/preferences/show-full-path-in-title-bar true
dconf write /org/nemo/preferences/show-open-in-terminal-toolbar true
dconf write /org/nemo/preferences/thumbnail-limit "uint64 10485760"
dconf write /org/nemo/preferences/default-sort-order "'mtime'"
dconf write /org/nemo/preferences/default-sort-in-reverse-order true
dconf write /org/nemo/preferences/show-location-entry true
dconf write /org/nemo/preferences/date-format "'informal'"
dconf write /org/nemo/preferences/show-reload-icon-toolbar true
dconf write /org/nemo/preferences/show-new-folder-icon-toolbar true
dconf write /org/nemo/preferences/inherit-folder-viewer true
dconf write /org/nemo/preferences/swap-trash-delete true

# Firefox als standaard browser
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
xdg-mime default firefox.desktop text/html
xdg-mime default firefox.desktop application/xhtml+xml

touch "$MARKER"
