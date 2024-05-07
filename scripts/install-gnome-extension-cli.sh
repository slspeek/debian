#!/usr/bin/env bash
set -e

install-gnome-extension-cli.sh

$HOME/.local/bin/gext install 615 # AppIndicator and KStatusNotifier Support
