#!/usr/bin/env bash
USER_ID=$(id -u):$(id -g)
BATS_IMAGE=bats/bats:v1.10.0
BATS_CMD="docker run -it --rm --init -v "$PWD:/code" -u $USER_ID $BATS_IMAGE"

$BATS_CMD $*