#!/usr/bin/env bash
set -e

wget --no-verbose https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -P /tmp
apt-get install --yes /tmp/chrome-remote-desktop_current_amd64.deb