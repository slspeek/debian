#!/usr/bin/env bash

FAILURE_DIR=/var/log/installer-preseed/late-cmd/failed

if [ -n "$(ls $FAILURE_DIR)" ]; then
    less $FAILURE_DIR/*.log
else
    echo No errors in late command execution
fi
