#!/bin/bash

# Detener el script si algo falla
set -e

echo "--- 1. Actualizando sistema e instalando paquetes de Repo y AUR ---"

yay -Syu --needed \
linux-zen linux-zen-headers zram-generator earlyroom \
timeshift vivaldi kitty qbittorrent bitwarden github-cli lazygit \
cohesion-git gimp flatpak inkscape peazip tree spotify spicetify-cli \
wmctrl micro xclip fastfetch stow lsd bat zoxide unzip \
zsh zsh-syntax-highlighting zsh-autosuggestions zsh-sudo zsh-autopair \
bibata-cursor-theme ttf-firacode-nerd inter-font  --noconfirm


echo "--- 2. Configurando Entorno ZSH (Oh My Zsh & P10k) ---"
#parte agregada para cambiar la shell
sudo usermod --shell /bin/zsh justin

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

echo "--- 4.5 Configurando Spicetify ---"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify backup apply

echo "--- 5. Activando Servicios de Usuario (Systemd) ---"
# Esto activa los .timer que tienes en tu carpeta de dotfiles
systemctl --user daemon-reload
systemctl --user enable --now apagar.timer ejercicio.timer
echo "--- 5.5 Activando servicios adicionales (Cronie & EarlyOOM) ---"
sudo systemctl enable --now cronie
sudo systemctl enable --now earlyoom

echo "--- 6. Activando Kernel-zen y zram ---"

#activar kernel-zen
sudo grub-mkconfig -o /boot/grub/grub.cfg

#activar y configurar zram
echo "--- Configurando zram ---"
sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF'

# Activar sin reiniciar
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "--- 7. Automatizando Personalización de Root ---"

# Cambiar shell de root
sudo chsh -s /bin/zsh root

# Instalar Oh My Zsh para Root (si no existe)
if [ ! -d "/root/.oh-my-zsh" ]; then
    echo "Instalando Oh My Zsh para Root..."
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instalar Powerlevel10k para Root
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k 2>/dev/null || echo "P10k ya instalado en root"

# Crear links simbólicos ABSOLUTOS (apuntando a tu repo en home)
# Usamos -sf para forzar el link y sobreescribir lo que haya
sudo ln -sf "$DOTFILES_DIR/todo/.zshrc" /root/.zshrc
sudo ln -sf "$DOTFILES_DIR/todo/.p10k.zsh" /root/.p10k.zsh

echo "--- 8. Configuración Final de GitHub ---"
if ! gh auth status &>/dev/null; then
    echo "Sugerencia: Ejecuta 'gh auth login' para vincular tu cuenta de GitHub."
    echo "Esto evitará que tengas que usar tokens o contraseñas manualmente."
fi

echo "-------------------------------------------------------"
echo "¡PROCESO FINALIZADO CON ÉXITO!"
echo "Reinicia la terminal o ejecuta: source ~/.zshrc"
echo "-------------------------------------------------------"
