#!/usr/bin/env bash
# set -e 

LATE_CMD_SRC=${LATE_CMD_SRC:-/usr/local/bin/late-cmds.sh}
LATE_CMD_LOGGING_DIR=${LATE_CMD_LOGGING_DIR:-/var/log/installer-preseed/late-cmd}

function run_logged() {
    CMD_FILE=$1
    $CMD_FILE > ${LATE_CMD_LOGGING_DIR}/$(basename ${CMD_FILE}).log 2>&1
}

source $LATE_CMD_SRC

declare -A results

for LATE_CMD_NAME in "$@";
do
    run_logged $LATE_CMD_NAME;
    results[$LATE_CMD_NAME]="$?"
done

RUN_LATER="LATE_CMD_LOGGING_DIR=$LATE_CMD_LOGGING_DIR LATE_CMD_SRC=$LATE_CMD_SRC late-cmd-helper.sh "
for KEY in "$@"
do
    if test "${results[$KEY]}" != "0";
    then 
        echo $KEY failed, see $LATE_CMD_LOGGING_DIR/$KEY.log 
        (cd $LATE_CMD_LOGGING_DIR/failed && ln -s $LATE_CMD_LOGGING_DIR/$KEY.log)
        ERROR=true
        RUN_LATER="${RUN_LATER} $KEY"
    fi
done

if test -n "$ERROR"; 
then 
    echo You can try to run 
    echo $RUN_LATER
    echo as root to retry the failed late-cmds
else
    echo All late-cmds successfully succeeded 
fi 

test -z "$ERROR"