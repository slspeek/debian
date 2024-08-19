#!/usr/bin/env bash
set -e

SHORTCUTS_DONE=$HOME/.config/set-shortcuts-done
test -f $SHORTCUTS_DONE && exit 0
set-les3-shortcuts.sh

setcustomshortcut.py "Visual studio code" code "<Super>c"
setcustomshortcut.py "Normale lettergrootte" /usr/local/bin/normal-scale.sh "<Super>minus"
setcustomshortcut.py "Dubbele lettergrootte" /usr/local/bin/double-scale.sh "<Super>equal"
setcustomshortcut.py "Verwissel muisknoppen" /usr/local/bin/mouse-key-toggle.sh "<Super><Control>m"
setcustomshortcut.py "Start screenkey" screenkey "<Super><Control>s"
setcustomshortcut.py "Stop screenkey" "pkill screenkey" "<Super><Shift><Control>s"
gsettings set org.gnome.settings-daemon.plugins.media-keys decrease-text-size "['<Super>F11']"
gsettings set org.gnome.settings-daemon.plugins.media-keys increase-text-size "['<Super>F12']"
mkdir -p ~/.config && echo yes > $SHORTCUTS_DONE