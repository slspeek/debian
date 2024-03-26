#!/usr/bin/env bash
set -e

wget --directory-prefix=/tmp --no-verbose https://slspeek.github.io/debian/scripts.tar.gz 
tar -C /usr/local/bin -xzf /tmp/scripts.tar.gz
