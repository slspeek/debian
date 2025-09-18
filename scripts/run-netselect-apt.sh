#!/usr/bin/env bash
set -e

cd /etc/apt/
netselect-apt --nonfree
sed -i -e 's/main contrib non-free/main contrib non-free non-free-firmware/g' sources.list
sed -i -e 's|http://security.debian.org/ stable/updates|http://security.debian.org/debian-security trixie-security|g' sources.list
apt-get update