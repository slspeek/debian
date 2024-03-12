#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../scripts:$PATH"

    export LATE_CMD_LOGGING_DIR=$(mktemp -d)
    LATE_CMD_SRC_TMP=$(mktemp)
    cat > $LATE_CMD_SRC_TMP << EOF
function success() {
    echo success
    true
}

function failure() {
    echo failure
    false
}

EOF
   
    export LATE_CMD_SRC=$LATE_CMD_SRC_TMP
}


@test "Single success" {
    late-cmd-helper.sh success
}

@test "Failure" {
    ! late-cmd-helper.sh success failure
}

@test "Failure reverse order" {
    ! late-cmd-helper.sh success failure
}


@test "Single failure: wrong name, output" {
    run late-cmd-helper.sh success_1
    assert_output --partial "Running: success_1"
    assert_output --partial "success_1 failed"
    assert_output --partial "success_1.log"
    assert_output --partial "late-cmd-helper.sh success_1"
}

@test "Failure output" {
    run late-cmd-helper.sh success failure
    assert_output --partial  "Running: success"
    assert_output --partial "Running: failure"
    assert_output --partial "late-cmd-helper.sh failure"
}