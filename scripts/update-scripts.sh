#!/usr/bin/env bash

SCRIPTS_URL=https://slspeek.github.io/debian/scripts.tar.gz

wget -qO- ${SCRIPTS_URL} | tar xvz -C /usr/local/bin
