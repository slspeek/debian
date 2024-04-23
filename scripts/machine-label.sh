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

if ! which make &> /dev/null
then 
    sudo apt install -y make && PURGEMAKE=true
fi

if ! which inxi &> /dev/null
then
    sudo apt install -y inxi && PURGEINXI=true
fi

make PASSWORD=$PASSWORD BOOTMENUKEY=$BOOTMENUKEY generate_pdf

if [ "$PURGEMAKE" = "true" ]; then
    sudo apt purge -y make
fi

if [ "$PURGEINXI" = "true" ]; then
    sudo apt purge -y inxi
fi

cp build/debian-machine-label.pdf ~

cd ~

rm -rf $TMPDIR
