#!/usr/bin/env bash
set -e

wget --no-verbose https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb -P /tmp
apt-get install --yes /tmp/google-earth-stable*.deb