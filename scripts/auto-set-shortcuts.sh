#!/bin/bash


USER=$1

cat > /usr/share/applications/set-shortcuts-setup.desktop << EOF
[Desktop Entry]
Name[en_GB]=Initial Shortcuts Setup
# Translators: Do NOT translate or transliterate this text (this is an icon file name)!
Exec=/usr/local/bin/set-shortcuts.sh
Type=Application
StartupNotify=true
Categories=GNOME;GTK;System;
OnlyShowIn=GNOME;
NoDisplay=true
X-GNOME-HiddenUnderSystemd=true
EOF

sudo -u $USER /bin/sh -c 'mkdir -p ~/.config/autostart && cp /usr/share/applications/set-shortcuts-setup.desktop ~/.config/autostart'

