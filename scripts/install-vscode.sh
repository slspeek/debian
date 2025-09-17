#!/usr/bin/env bash
set -e

apt-get install -qq --yes extrepo
extrepo enable vscode
apt-get -qq update || true # ignore cdrom entry that is not yet disabled during the late-cmd execution
apt-get install -qq --yes code