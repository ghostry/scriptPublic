#!/bin/bash
Yaru="/usr/share/gnome-shell/theme/Yaru"
mytheme="/usr/share/gnome-shell/theme/mytheme"
gs="${mytheme}/gnome-shell-theme.gresource"
if [ ! -d ${mytheme} ]; then
    sudo cp -r ${Yaru} ${mytheme}
    sudo rm ${gs}
fi
sudo mv gnome-shell-theme.gresource $gs
sudo update-alternatives --install /usr/share/gnome-shell/gdm3-theme.gresource gdm3-theme.gresource $gs 16
sudo update-alternatives --auto gdm3-theme.gresource
sudo update-alternatives --config gdm3-theme.gresource
