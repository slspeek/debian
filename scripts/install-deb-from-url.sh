#!/usr/bin/env bash
set -e

URL=$1
DEB_FILE=$(basename $URL)

TEMPDIR=$(mktemp -d)
cd $TEMPDIR

wget --no-verbose $URL
DEBIAN_FRONTEND=noninteractive apt-get install --yes -qq ./$DEB_FILE