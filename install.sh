#!/bin/bash
# install.sh — Arch Linux setup script
# Gebruik: bash install.sh
# Vereist: verse Arch installatie met internet, als gewone gebruiker (niet root)

set -euo pipefail
COLOR="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

step()  { echo -e "\n${COLOR}==>${RESET} $1"; }
skip()  { echo -e "  ${GREEN}✓${RESET} $1 — al gedaan, overgeslagen."; }
warn()  { echo -e "  ${YELLOW}⚠${RESET} $1"; }

# ── 1. Pacman optimaliseren ───────────────────────────────────────────────
step "Pacman database updaten en systeem upgraden..."
sudo pacman -Syu --noconfirm

step "Pacman instellen..."
if grep -q "^#ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
else
    skip "pacman.conf"
fi

if grep -q "^#MAKEFLAGS" /etc/makepkg.conf; then
    sudo sed -i "s/^#MAKEFLAGS.*/MAKEFLAGS=\"-j\$(nproc)\"/" /etc/makepkg.conf
else
    skip "makepkg.conf"
fi

# ── 2. Yay (AUR helper) ───────────────────────────────────────────────────
step "Yay installeren..."
if ! command -v yay &>/dev/null; then
    sudo pacman -Sy --needed --noconfirm git base-devel
    yay_tmp="$(mktemp -d /tmp/yay-bin.XXXXXX)"
    trap 'rm -rf "$yay_tmp"' EXIT
    git clone https://aur.archlinux.org/yay-bin.git "$yay_tmp"
    (cd "$yay_tmp" && makepkg -si --noconfirm)
    rm -rf "$yay_tmp"
    trap - EXIT
else
    skip "yay"
fi

# ── 3. Pacman packages ────────────────────────────────────────────────────
step "Pacman packages installeren..."
sudo pacman -S --needed --noconfirm \
    bluez bluez-utils \
    alsa-plugins \
    avahi \
    base base-devel \
    brightnessctl \
    btop \
    btrfs-progs \
    cava \
    chromium \
    cliphist \
    curl \
    discord \
    docker docker-compose \
    earlyoom \
    efibootmgr \
    fastfetch \
    firefox \
    git \
    grub \
    hypridle hyprland hyprlock hyprpaper \
    hyprpolkitagent \
    hyprshot \
    inotify-tools \
    iw iwd \
    jq \
    kitty \
    lazydocker \
    linux linux-firmware linux-headers \
    ly \
    man-db \
    nano nano-syntax-highlighting \
    nemo nemo-fileroller \
    networkmanager \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-liberation \
    ntfs-3g \
    openssh \
    openvpn \
    pacman-contrib \
    pamixer \
    pavucontrol \
    pipewire pipewire-alsa pipewire-jack pipewire-pulse \
    playerctl \
    pulsemixer \
    python-pywal \
    remmina \
    rofi \
    spotify-launcher \
    sudo \
    swaync \
    tailscale \
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common \
    udiskie \
    unzip \
    usbutils \
    viewnior \
    vim \
    vlc \
    waybar \
    wget \
    wireplumber \
    wl-clipboard \
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
    xdg-utils \
    yt-dlp \
    zram-generator \
    zsh zsh-autosuggestions zsh-completions

# ── 4. AUR packages ───────────────────────────────────────────────────────
step "AUR packages installeren..."
aur_packages=(
    firefoxpwa
    grimblast-git
    impala
    pacseek
    ttf-symbola
    vscodium-bin
    wlogout
)
for pkg in "${aur_packages[@]}"; do
    echo -e "  → $pkg installeren..."
    yay -S --needed --noconfirm "$pkg" || echo -e "  ⚠ $pkg gefaald, verder..."
done

# ── 5. Zsh als standaard shell ────────────────────────────────────────────
step "Zsh instellen als standaard shell..."
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/usr/bin/zsh" ]; then
    if [ -t 0 ]; then
        chsh -s /usr/bin/zsh "$USER"
    else
        warn "Geen interactieve TTY; chsh overgeslagen. Zet later handmatig: chsh -s /usr/bin/zsh $USER"
    fi
else
    skip "standaard shell (al zsh)"
fi

# ── 6. Dotfiles clonen ────────────────────────────────────────────────────
step "Dotfiles ophalen..."
if [ ! -d "$HOME/.config/.git" ]; then
    backup_dir="$HOME/.config.bak"
    if [ -e "$backup_dir" ]; then
        backup_dir="$HOME/.config.bak.$(date +%Y%m%d-%H%M%S)"
    fi
    mv "$HOME/.config" "$backup_dir" 2>/dev/null || true
    git clone https://github.com/Donixon/dotfiles.git "$HOME/.config"
    if [ -d "$backup_dir" ]; then
        cp -rn "$backup_dir/." "$HOME/.config/" 2>/dev/null || true
    fi
else
    skip "dotfiles clone (al aanwezig, pullen...)"
    git -C "$HOME/.config" pull
fi

# Pywal kleuren genereren voor eerste Hyprland start
if [ ! -s "$HOME/.cache/wal/colors-hyprland.conf" ]; then
    mkdir -p "$HOME/.cache/wal"
    wal -i "$HOME/.config/hypr/wallpapers/natuur005.jpg" -n -q || \
        touch "$HOME/.cache/wal/colors-hyprland.conf"  # fallback: leeg bestand zodat Hyprland niet crasht
else
    skip "pywal kleuren"
fi

# ── 7. Symlinks aanmaken ──────────────────────────────────────────────────
step "Symlinks aanmaken..."
ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"

# Nemo acties en scripts
mkdir -p "$HOME/.local/share/nemo/actions" "$HOME/.local/share/nemo/scripts"
cp "$HOME/.config/nemo/actions/"* "$HOME/.local/share/nemo/actions/" 2>/dev/null || true
cp "$HOME/.config/nemo/scripts/"* "$HOME/.local/share/nemo/scripts/" 2>/dev/null || true
chmod +x "$HOME/.local/share/nemo/scripts/"* 2>/dev/null || true

# ── 8. Locale instellen ──────────────────────────────────────────────────
step "Locale instellen..."
locale_changed=0
if ! grep -q "^en_US.UTF-8" /etc/locale.gen 2>/dev/null; then
    sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
    locale_changed=1
fi
if ! grep -q "^nl_NL.UTF-8" /etc/locale.gen 2>/dev/null; then
    sudo sed -i 's/^#nl_NL.UTF-8/nl_NL.UTF-8/' /etc/locale.gen
    locale_changed=1
fi
if [ "$locale_changed" -eq 1 ]; then
    sudo locale-gen
else
    skip "locale.gen"
fi

if ! grep -q "^LANG=en_US.UTF-8" /etc/locale.conf 2>/dev/null; then
    echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
else
    skip "locale.conf"
fi

# Zram config
if [ ! -f /etc/systemd/zram-generator.conf ]; then
    sudo tee /etc/systemd/zram-generator.conf > /dev/null << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF
else
    skip "zram-generator.conf"
fi

# Ly display manager config
if ! grep -q "autologin_user = $(whoami)" /etc/ly/config.ini 2>/dev/null; then
    sudo cp "$HOME/.config/ly/config.ini" /etc/ly/config.ini
    sudo sed -i "s/{USER}/$(whoami)/" /etc/ly/config.ini
else
    skip "ly config"
fi

# Font cache verversen
fc-cache -fv

# ── 9. Netwerk instellen (iwd + NetworkManager voor tooling compatibiliteit) ──
step "Netwerkservices instellen..."

# iwd bewaart bekende netwerken in /var/lib/iwd
sudo install -d -m 700 /var/lib/iwd

# iwd basisconfig voor persistente netwerken + DHCP/DNS via systemd
sudo mkdir -p /etc/iwd
sudo tee /etc/iwd/main.conf > /dev/null << 'EOF'
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

# NetworkManager iwd-backend (zodat nmcli/nmtui en iwd elkaar niet bijten)
sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/iwd.conf > /dev/null << 'EOF'
[device]
wifi.backend=iwd
EOF

# ── 10. Services aanzetten ───────────────────────────────────────────────
step "Services aanzetten..."
# wpa_supplicant conflicteert met iwd
if systemctl is-enabled wpa_supplicant &>/dev/null || systemctl is-active wpa_supplicant &>/dev/null; then
    sudo systemctl disable --now wpa_supplicant
else
    skip "wpa_supplicant uitschakelen (al uit)"
fi

for svc in NetworkManager iwd bluetooth docker earlyoom tailscaled avahi-daemon systemd-resolved systemd-timesyncd sshd; do
    if ! systemctl is-enabled "$svc" &>/dev/null; then
        sudo systemctl enable "$svc"
    else
        skip "service $svc (enabled)"
    fi

    if ! systemctl is-active "$svc" &>/dev/null; then
        sudo systemctl start "$svc"
    else
        skip "service $svc (active)"
    fi
done

# Extra zekerheid voor eerste reboot: NM/iwd moeten écht actief zijn
for svc in NetworkManager iwd; do
    if ! systemctl is-active "$svc" &>/dev/null; then
        warn "service $svc was niet actief, probeer restart..."
        sudo systemctl restart "$svc" || true
    fi
    if ! systemctl is-active "$svc" &>/dev/null; then
        warn "service $svc is nog steeds niet actief"
    fi
done

# Ly display manager (template unit, vereist instantie)
if ! systemctl is-enabled "ly@tty2.service" &>/dev/null; then
    sudo systemctl enable --now ly@tty2.service
else
    skip "service ly"
fi

# systemd-resolved stub resolver gebruiken (zonder bestaande custom resolv.conf te overschrijven)
resolved_stub="/run/systemd/resolve/stub-resolv.conf"
current_resolv="$(readlink -f /etc/resolv.conf 2>/dev/null || true)"
if [ "$current_resolv" = "$resolved_stub" ]; then
    skip "resolv.conf symlink"
elif [ ! -e "$resolved_stub" ]; then
    warn "systemd-resolved stub ontbreekt; /etc/resolv.conf niet aangepast."
elif [ -L /etc/resolv.conf ] || [ ! -s /etc/resolv.conf ]; then
    sudo ln -sf "$resolved_stub" /etc/resolv.conf
else
    warn "Bestaande /etc/resolv.conf behouden (niet overschreven)."
fi

systemctl --user enable --now wireplumber || true

echo ""
echo -e "${COLOR}======================================${RESET}"
echo -e "${COLOR} Installatie klaar!${RESET}"
echo -e "${COLOR}======================================${RESET}"
echo ""
echo "Volgende stappen:"
echo "  1. Herstart je systeem"
echo "  2. Log in via ly"
echo "  3. VPN config toevoegen in /etc/openvpn/"
echo ""
echo "Let op na eerste login:"
echo "  - Monitornamen aanpassen in hypr/hyprland.conf en hypr/hyprpaper.conf"
echo "    (gebruik 'hyprctl monitors' om je monitornamen te zien)"
echo "  - Als audio niet werkt: systemctl --user enable --now wireplumber"
echo ""
