#!/usr/bin/env bash
set -e

PASSWORD=${2:-tux}
BOOTMENUKEY=${1:-F12}

TMPDIR=$(mktemp -d)

cd $TMPDIR

if ! which git &> /dev/null
then
    sudo apt install -y git && PURGEGIT=true
fi

git clone https://github.com/slspeek/debian-machine-label.git

if [ "$PURGEGIT" = "true" ]; then
    sudo apt purge -y git
fi

cd debian-machine-label

# echo Bootmenukey: $BOOTMENUKEY
# echo Password: $PASSWORD

make PASSWORD=$PASSWORD BOOTMENUKEY=$BOOTMENUKEY generate_pdf

cp build/debian-machine-label.pdf ~

cd ~

rm -rf $TMPDIR


