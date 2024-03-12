#!/usr/bin/env bash
set -e

PRESEED_NAME=$1

cd /var/log/ 
mkdir installer-preseed
cd installer-preseed
wget --no-verbose https://slspeek.github.io/debian/$PRESEED_NAME
