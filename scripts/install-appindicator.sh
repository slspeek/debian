#!/usr/bin/env bash
set -e

pipx install gnome-extensions-cli --system-site-packages

pipx ensurepath

$HOME/.local/bin/gext install 615 # AppIndicator and KStatusNotifier Support
