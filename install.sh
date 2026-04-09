#!/bin/bash
# install.sh — Arch Linux setup script voor donixon
# Gebruik: bash install.sh
# Vereist: verse Arch installatie met internet, als gewone gebruiker (niet root)

set -e
COLOR="\033[1;34m"
RESET="\033[0m"

step() { echo -e "\n${COLOR}==>${RESET} $1"; }

# ── 1. Yay (AUR helper) ───────────────────────────────────────────────────
step "Yay installeren..."
if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    (cd /tmp/yay-bin && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bin
else
    echo "Yay al aanwezig."
fi

# ── 2. Pacman packages ────────────────────────────────────────────────────
step "Pacman packages installeren..."
sudo pacman -S --needed --noconfirm \
    alsa-plugins \
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
    grub grub-btrfs \
    gsimplecal \
    hypridle hyprland hyprlock hyprpaper \
    hyprpolkitagent \
    hyprshot \
    impala \
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
    noto-fonts-cjk noto-fonts-emoji \
    ntfs-3g \
    openssh \
    openvpn \
    pacman-contrib \
    pamixer \
    pavucontrol \
    pipewire pipewire-alsa pipewire-jack \
    playerctl \
    pulseaudio \
    pulsemixer \
    python-pywal \
    remmina \
    rofi \
    spotify-launcher \
    sudo \
    swaync \
    tailscale \
    timeshift \
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
    udiskie \
    unzip \
    usbutils \
    vim \
    vlc \
    waybar \
    wget \
    wireplumber \
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
    yt-dlp \
    zram-generator \
    zsh zsh-autosuggestions zsh-completions

# ── 3. AUR packages ───────────────────────────────────────────────────────
step "AUR packages installeren..."
yay -S --needed --noconfirm \
    grimblast-git \
    notepad \
    pacseek \
    teamspeak \
    timeshift-autosnap \
    ttf-symbola \
    vscodium-bin \
    wlogout \
    firefoxpwa \
    viewnior

# ── 4. Zsh als standaard shell ────────────────────────────────────────────
step "Zsh instellen als standaard shell..."
chsh -s /usr/bin/zsh

# ── 5. SSH key aanmaken ───────────────────────────────────────────────────
step "SSH key aanmaken..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -C "roseshop@tuta.io" -f "$HOME/.ssh/id_ed25519" -N ""
    echo ""
    echo "Voeg deze SSH key toe aan GitHub (github.com/settings/ssh/new):"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    read -p "Druk Enter als je de key hebt toegevoegd..."
fi

# SSH config voor GitHub (port 443 fallback)
mkdir -p "$HOME/.ssh"
if ! grep -q "ssh.github.com" "$HOME/.ssh/config" 2>/dev/null; then
    cat >> "$HOME/.ssh/config" << 'EOF'

Host github.com
    Hostname ssh.github.com
    Port 443
    User git
EOF
fi

# ── 6. Dotfiles clonen ────────────────────────────────────────────────────
step "Dotfiles ophalen..."
if [ ! -d "$HOME/.config/.git" ]; then
    mv "$HOME/.config" "$HOME/.config.bak" 2>/dev/null || true
    git clone git@github.com:Donixon/dotfiles.git "$HOME/.config"
    cp -rn "$HOME/.config.bak/." "$HOME/.config/" 2>/dev/null || true
else
    echo "Dotfiles al aanwezig, pullen..."
    git -C "$HOME/.config" pull
fi

# ── 7. Symlinks aanmaken ──────────────────────────────────────────────────
step "Symlinks aanmaken..."
ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"

# ── 8. Secrets aanmaken ───────────────────────────────────────────────────
SECRETS="$HOME/.config/waybar/scripts/secrets.env"
if [ ! -f "$SECRETS" ]; then
    step "OpenWeatherMap API key instellen..."
    read -p "Voer je OpenWeatherMap API key in: " OWM_KEY
    echo "API_KEY=\"$OWM_KEY\"" > "$SECRETS"
fi

# ── 9. GTK dark mode ─────────────────────────────────────────────────────
step "Dark mode instellen..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

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

# ── 10. Git instellen ────────────────────────────────────────────────────
step "Git configureren..."
git config --global user.name "donixon"
git config --global user.email "roseshop@tuta.io"

# ── 11. Services aanzetten ───────────────────────────────────────────────
step "Services aanzetten..."
sudo systemctl enable --now \
    NetworkManager \
    docker \
    earlyoom \
    iwd \
    tailscaled \
    avahi-daemon \
    systemd-resolved \
    systemd-timesyncd \
    sshd

systemctl --user enable --now wireplumber

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
