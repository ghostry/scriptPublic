#!/bin/bash
gs="/usr/share/gnome-shell/gdm3-theme.gresource"
if [ ! -d gnome-shell-theme ]; then
    mkdir -p gnome-shell-theme/Yaru
    mkdir -p gnome-shell-theme/Yaru-dark
    mkdir -p gnome-shell-theme/icons/scalable/actions
    mkdir -p gnome-shell-theme/icons/scalable/status
fi
for r in `gresource list $gs`; do
    gresource extract $gs $r > gnome-shell-theme/${r/#\/org\/gnome\/shell\/theme/.}
done
