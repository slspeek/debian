#!/bin/bash

function run_logged() {
    CMD_FILE=$1
    $CMD_FILE > ${LATE_CMD_LOGGING_DIR}/$(basename ${CMD_FILE}).log 2>&1
}

declare -A results

for LATE_CMD_NAME in "$@";
do
    echo $LATE_CMD_NAME
    run_logged $LATE_CMD_NAME
    results[$LATE_CMD_NAME]=$?
done

(for KEY in ${!results[@]}
do
    if test result[$KEY] -ne 0;
        then echo $KEY failt
    fi
done)  

