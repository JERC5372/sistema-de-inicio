#!/bin/bash

# Detener el script si algo falla
set -e

echo "--- 1. Actualizando sistema e instalando paquetes de Repo y AUR ---"

# He añadido 'stow', 'lsd' y 'bat' que son necesarios para tus alias y gestión
yay -Syu --needed \
timeshift vivaldi cohesion-git qbittorrent bitwarden \
kitty bibata-cursor-theme flatpak inkscape zsh \
zsh-syntax-highlighting zsh-autosuggestions zsh-sudo \
wps-office ttf-wps-fonts gimp lotion micro fastfetch \
peazip stow lsd bat --noconfirm

echo "--- 2. Configurando Entorno ZSH (Oh My Zsh & P10k) ---"

# Instalar Oh My Zsh (modo desatendido para que no cierre el script)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instalar Tema Powerlevel10k
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Instalando Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

echo "--- 3. Configurando Repositorios Externos (Flatpak) ---"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.videolan.VLC -y

echo "--- 4. Aplicando Dotfiles con GNU Stow ---"

# Entrar a la carpeta de tus dotfiles
DOTFILES_DIR="$HOME/sistema-de-inicio"

if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"
    
    # Eliminar archivos por defecto que crean conflicto con Stow
    echo "Limpiando archivos de configuración antiguos..."
    rm -f "$HOME/.zshrc"
    rm -f "$HOME/.p10k.zsh"
    
    # Aplicar stow a la carpeta 'todo'
    stow todo
    echo "¡Dotfiles vinculados con éxito!"
else
    echo "ERROR: No se encontró la carpeta $DOTFILES_DIR"
    exit 1
fi

echo "--- 5. Activando Servicios de Usuario (Systemd) ---"
# Esto activa los .timer que tienes en tu carpeta de dotfiles
systemctl --user daemon-reload
systemctl --user enable --now apagar.timer ejercicio.timer

echo "-------------------------------------------------------"
echo "¡PROCESO FINALIZADO CON ÉXITO!"
echo "Reinicia la terminal o ejecuta: source ~/.zshrc"
echo "-------------------------------------------------------"