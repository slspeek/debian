#!/usr/bin/env bash
set -e

apt-get install -y software-properties-common apt-transport-https curl
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt-get update
apt-get install -y code