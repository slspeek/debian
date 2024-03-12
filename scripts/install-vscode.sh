#!/usr/bin/env bash
set -e

apt-get install -q --yes software-properties-common apt-transport-https curl
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository --yess "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt-get -q update || true # ignore cdrom entry that is not yet disabled during the late-cmd execution
apt-get install -q --yess code