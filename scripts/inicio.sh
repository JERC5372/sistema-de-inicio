#Programas instalacion
yay -Syu timeshift vivaldi qbittorrent bitwarden kitty bibata-cursor-theme flatpak inkscape zsh zsh-syntax-highlighting zsh-autosuggestions zsh-sudo wps-office ttf-wps-fonts gimp lotion micro fastfetch peazip --noconfirm

#flatpak repositorio
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Configurar español wl wps office
git clone https://github.com/CodigoCristo/wpsoffice.git

#instalr vlc en flatpack
flatpak install flathub org.videolan.VLC
