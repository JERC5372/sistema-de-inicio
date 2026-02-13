#!/bin/bash


echo "Creando directorios necesarios..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/micro
mkdir -p ~/.config/fastfetch
mkdir -p ~/.config/systemd/user
mkdir -p ~/scripts
mkdir -p ~/.config/awesome
echo "Creando symlinks..."

ln -sf ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -sf ~/dotfiles/kitty/color.ini ~/.config/kitty/color.ini

ln -sf ~/dotfiles/micro/settings.json ~/.config/micro/settings.json
ln -sf ~/dotfiles/micro/cold-mono-red.micro ~/.config/micro/cold-mono-red.micro

ln -sf ~/dotfiles/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc

ln -sf ~/dotfiles/systemd-user/ejercicio.service ~/.config/systemd/user/ejercicio.service

ln -sf ~/dotfiles/scripts/apagar.sh ~/scripts/apagar.sh
ln -sf ~/dotfiles/scripts/ejercicio.sh ~/scripts/ejercicio.sh
ln -sf ~/dotfiles/scripts/inicio.sh ~/scripts/inicio.sh
chmod +x ~/scripts/*.sh

ln -sf ~/dotfiles/awesome/rc.lua ~/.config/awesome/rc.lua

echo "Instalación terminada."
