#!/bin/bash

key="org.gnome.desktop.peripherals.mouse left-handed"
current=$(gsettings get $key)

if [ "$current" == "true" ]; then
  gsettings set $key false
else
  gsettings set $key true
fi