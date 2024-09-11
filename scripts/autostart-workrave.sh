#!/usr/bin/env bash
set -e

AUTOSTART=/etc/skel/.config/autostart
mkdir -p $AUTOSTART
cd $AUTOSTART
ln -s /usr/share/applications/workrave.desktop
