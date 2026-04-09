#!/bin/bash

VPN_CONF="/home/don/Documents/VPNConfig.ovpn"
PIDFILE="/tmp/myvpn.pid"

is_vpn_active() {
    [[ -f "$PIDFILE" ]] && ps -p "$(cat "$PIDFILE")" > /dev/null 2>&1
}

get_vpn_status() {
    if is_vpn_active; then
        echo '{"text": "󰆧 VPN", "class": "connected", "tooltip": "VPN: Verbonden"}'
    else
        echo '{"text": "󰤭 VPN", "class": "disconnected", "tooltip": "VPN: Niet verbonden"}'
    fi
}

toggle_vpn() {
    if is_vpn_active; then
        sudo kill "$(cat "$PIDFILE")"
        rm -f "$PIDFILE"
        notify-send "VPN" "Verbinding verbroken"
    else
        sudo openvpn --config "$VPN_CONF" --auth-user-pass /home/don/Documents/vpn_auth.txt --daemon --writepid "$PIDFILE"
        sleep 1
        if is_vpn_active; then
            notify-send "VPN" "Verbonden"
        else
            notify-send -u critical "VPN" "Verbinding mislukt"
        fi
    fi
}

case "$1" in
    --toggle) toggle_vpn ;;
    *)        get_vpn_status ;;
esac
