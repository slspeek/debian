#!/usr/bin/bats

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../scripts:$PATH"

    LATE_CMD_LOGGING_DIR=$(mktemp -d)
    LATE_CMD_SRC_TMP=$(mktemp)
    :>$LATE_CMD_SRC_TMP
    LATE_CMD_SRC=$LATE_CMD_SRC_TMP
    source late-cmd-helper.sh
}

@test "Failure detection" {
    TMP_FILE=$(mktemp)
    echo false>$TMP_FILE
    chmod +x $TMP_FILE
    ! run_logged $TMP_FILE
}

@test "Success" {
    TMP_FILE=$(mktemp)
    echo true>$TMP_FILE
    chmod +x $TMP_FILE
    run_logged $TMP_FILE
}

@test "Logging location" {
    TMP_FILE=$(mktemp)
    echo true>$TMP_FILE
    chmod +x $TMP_FILE

    ! test -e $LATE_CMD_LOGGING_DIR/$(basename ${TMP_FILE}).log
    run_logged $TMP_FILE
    test -e $LATE_CMD_LOGGING_DIR/$(basename ${TMP_FILE}).log
}

@test "Logging stdout" {
    TMP_FILE=$(mktemp)
    echo echo foo>$TMP_FILE
    chmod +x $TMP_FILE

    EXSPECTED_LOG_FILE=$(mktemp)
    echo foo>$EXSPECTED_LOG_FILE
    run_logged $TMP_FILE
    diff $LATE_CMD_LOGGING_DIR/$(basename ${TMP_FILE}).log $EXSPECTED_LOG_FILE
}

@test "Logging stderr" {
    TMP_FILE=$(mktemp)
cat > $TMP_FILE <<EOF
echo foo>&2
EOF
    chmod +x $TMP_FILE

    EXSPECTED_LOG_FILE=$(mktemp)
    echo foo>$EXSPECTED_LOG_FILE
    run_logged $TMP_FILE
    diff $LATE_CMD_LOGGING_DIR/$(basename ${TMP_FILE}).log $EXSPECTED_LOG_FILE
}