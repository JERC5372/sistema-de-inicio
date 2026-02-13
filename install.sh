#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

install_packages() {
    echo "Instalando dependencias base..."
    sudo pacman -S --needed base-devel git --noconfirm

    echo "Actualizando sistema..."
    yay -Syu --noconfirm

    echo "Instalando programas..."
    yay -S timeshift vivaldi qbittorrent bitwarden kitty \
    bibata-cursor-theme flatpak inkscape zsh \
    zsh-syntax-highlighting zsh-autosuggestions zsh-sudo \
    wps-office ttf-wps-fonts gimp lotion micro fastfetch peazip --noconfirm
}

setup_flatpak() {
    echo "Configurando flatpak..."
    flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

    flatpak install -y flathub org.videolan.VLC
}

setup_dotfiles() {
    echo "Creando directorios..."
    mkdir -p ~/.config/{kitty,micro,fastfetch,systemd/user,awesome}
    mkdir -p ~/scripts

    echo "Creando symlinks..."

    ln -sf "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf
    ln -sf "$DOTFILES_DIR/kitty/color.ini" ~/.config/kitty/color.ini

    ln -sf "$DOTFILES_DIR/micro/settings.json" ~/.config/micro/settings.json
    ln -sf "$DOTFILES_DIR/micro/cold-mono-red.micro" ~/.config/micro/cold-mono-red.micro

    ln -sf "$DOTFILES_DIR/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc

    ln -sf "$DOTFILES_DIR/systemd-user/ejercicio.service" \
    ~/.config/systemd/user/ejercicio.service

    ln -sf "$DOTFILES_DIR/scripts/apagar.sh" ~/scripts/apagar.sh
    ln -sf "$DOTFILES_DIR/scripts/ejercicio.sh" ~/scripts/ejercicio.sh

    ln -sf "$DOTFILES_DIR/awesome/rc.lua" ~/.config/awesome/rc.lua

    chmod +x ~/scripts/*.sh
}

main() {
    install_packages
    setup_flatpak
    setup_dotfiles
    echo "Sistema configurado correctamente."
}

main
