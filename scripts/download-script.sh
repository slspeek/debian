#!/bin/bash

SCRIPT=$1

REPO=https://raw.githubusercontent.com/slspeek/debian/main/scripts
cd /usr/local/bin
wget $REPO/$SCRIPT
chmod +x $SCRIPT
