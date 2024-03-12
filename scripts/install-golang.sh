#!/usr/bin/env bash
set -e

VERSION=1.22.0
GO_ARCHIVE=go${VERSION}.linux-amd64.tar.gz
cd /tmp
wget --no-verbose https://go.dev/dl/${GO_ARCHIVE}
if [ -d /usr/local/go ]; 
then 
    sudo rm -rf /usr/local/go
fi
sudo tar xzf ${GO_ARCHIVE} -C /usr/local
sudo /bin/sh -c 'echo export PATH=/usr/local/go/bin:\$PATH >> /etc/profile'

