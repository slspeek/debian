#!/bin/bash

function run_logged() {
    CMD_FILE=$1
    $CMD_FILE > ${LATE_CMD_LOGGING_DIR}/$(basename ${CMD_FILE}).log 2>&1
}

source $LATE_CMD_SRC

declare -A results

for LATE_CMD_NAME in "$@";
do
    echo $LATE_CMD_NAME
    run_logged $LATE_CMD_NAME
    results[$LATE_CMD_NAME]=$?
done

ERROR=""
RUN_LATER="LATE_CMD_LOGGING_DIR=/tmp LATE_CMD_SRC=/usr/local/bin/late-cmds.sh late-cmd-helper.sh "
(for KEY in ${!results[@]}
do
    if test result[$KEY] -ne 0;
    then 
        echo $KEY failed
        ERROR=true
        RUN_LATER="${RUN_LATER} $KEY"
    else
        echo $KEY successfully succeeded 
    fi
done) | tee $LATE_CMD_LOGGING_DIR/late-cmds.log



if test -n "$ERROR"; 
then 
  ( echo You can try to run 
    echo $RUN_LATER
    echo as root to retry the failed late-cmds) | tee $LATE_CMD_LOGGING_DIR/late-cmds.log
fi

test -z "$ERROR"