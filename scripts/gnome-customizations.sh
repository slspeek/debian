#!/usr/bin/env bash
set -e

gsettings set org.gnome.desktop.interface enable-hot-corners false

gsettings set org.gnome.desktop.screensaver lock-enabled false

gsettings set org.gnome.desktop.background picture-uri file:///usr/local/share/wallpaper/Noord-Hollands-Duinreservaat.jpg

