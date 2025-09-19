#!/usr/bin/env bash
set -e
# from https://element.io/download#linux
export DEBIAN_FRONTEND=noninteractive 
sudo apt-get install -y wget apt-transport-https
sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg \
  https://packages.element.io/debian/element-io-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] \
https://packages.element.io/debian/ default main" \
| sudo tee /etc/apt/sources.list.d/element-io.list
sudo apt-get update || true
sudo apt-get install -y element-desktop



