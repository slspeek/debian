#!/usr/bin/env bash
set -e

install-deb-from-url.sh https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb 
apt-get -qq update || true
apt-get install --yes -qq dotnet-sdk-8.0