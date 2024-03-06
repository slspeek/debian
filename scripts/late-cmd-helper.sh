#!/bin/bash

function run_logged() {
    CMD_FILE=$1
    $CMD_FILE > ${LATE_CMD_LOGGING_DIR}/$(basename ${CMD_FILE}).log 2>&1
}

