#!/usr/bin/env bash
set -e

SHORTCUTS_DONE=$HOME/.config/set-les3-shortcuts-done
test -f $SHORTCUTS_DONE && exit 1
setcustomshortcut.py Terminal gnome-terminal "<Control><Alt>t"
setcustomshortcut.py "Afstellingen" gnome-tweaks "<Super><Shift>i"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"
mkdir -p ~/.config && echo yes > $SHORTCUTS_DONE