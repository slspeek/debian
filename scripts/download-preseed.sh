#!/usr/bin/env bash

PRESEED_NAME=$1

cd /var/log/ && \
mkdir installer-preseed && cd installer-preseed && \
wget https://slspeek.github.io/debian/$PRESEED_NAME
