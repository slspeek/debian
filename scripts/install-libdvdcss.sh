#!/usr/bin/env bash
set -e

DEBIAN_FRONTEND=noninteractive apt-get install -y libdvd-pkg
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg