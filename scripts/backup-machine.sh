#!/usr/bin/env bash
set -e

TARGETDIR=${1:-/tmp}

TIMESTAMP=$(date +%Y%m%d-%H%M)

ARCHIVE=backup-${TIMESTAMP}.tar.xz

tar cvJf $TARGETDIR/$ARCHIVE /home /root /etc

echo Created backup archive: $ARCHIVE in $TARGETDIR

