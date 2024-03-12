#!/usr/bin/env bash
set -e

USER=$1

cat > /etc/xdg/autostart/set-shortcuts-setup.desktop << EOF
[Desktop Entry]
Name[en_GB]=Initial Shortcuts Setup
Name=Initial Shortcuts Setup
# Translators: Do NOT translate or transliterate this text (this is an icon file name)!
Icon=preferences-system
Exec=/usr/local/bin/set-shortcuts.sh
Terminal=false
Type=Application
StartupNotify=true
Categories=GNOME;GTK;System;
OnlyShowIn=GNOME;
NoDisplay=true
X-GNOME-Autostart-enabled=true
AutostartCondition=unless-exists set-shortcuts-done
X-GNOME-HiddenUnderSystemd=true
EOF

# sudo -u $USER /bin/sh -c 'mkdir -p ~/.config/autostart && cp /usr/share/applications/set-shortcuts-setup.desktop ~/.config/autostart'

