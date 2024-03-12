#!/usr/bin/env bash
set -e

cd /tmp
wget --no-verbose https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb
