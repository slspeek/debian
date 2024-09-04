#!/usr/bin/env bash
set -e

gsettings set org.gnome.desktop.interface enable-hot-corners false

gsettings set org.gnome.desktop.screensaver lock-enabled false

WALLPAPER=/usr/local/share/wallpaper/Noord-Hollands-Duinreservaat.jpg
if [ -f "$WALLPAPER" ];
then
    gsettings set org.gnome.desktop.background picture-uri "file://${WALLPAPER}"
    gsettings set org.mate.background picture-filename $WALLPAPER
fi

