#!/usr/bin/env bash
set -e

TEMPDIR=$(mktemp -d)

cd $TEMPDIR

wget --no-verbose https://mega.nz/linux/repo/Debian_12/amd64/megasync-Debian_12_amd64.deb
sudo apt-get install --yes ./megasync-Debian_12_amd64.deb
