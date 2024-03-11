#!/usr/bin/bats

setup() {
    source /usr/lib/bats/bats-support/load.bash
    source /usr/lib/bats/bats-assert/load.bash
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../scripts:$PATH"

    export LATE_CMD_LOGGING_DIR=$(mktemp -d)
    LATE_CMD_SRC_TMP=$(mktemp)
    cat > $LATE_CMD_SRC_TMP << EOF
function success_one() {
    echo success one
    true
}

function success_two() {
    echo success two
    true
}

EOF
   
    export LATE_CMD_SRC=$LATE_CMD_SRC_TMP
}


@test "Single success" {
    late-cmd-helper.sh success_one
}

@test "Single failure: wrong name" {
    ! late-cmd-helper.sh success_1
}

@test "Single failure: wrong name, output" {
    run late-cmd-helper.sh success_1
    assert_output --partial "Running: success_1"
    assert_output --partial "success_1 failed"
    assert_output --partial "success_1.log"
    assert_output --partial "late-cmd-helper.sh success_1"
}

@test "Single success output" {
    run late-cmd-helper.sh success_one
    assert_output --partial "Running: success_one"
    assert_output --partial "All late-cmds successfully succeeded"
}

@test "Double success output" {
    run late-cmd-helper.sh success_one success_two
    assert_output --partial "Running: success_one"
    assert_output --partial "Running: success_two"
    assert_output --partial "All late-cmds successfully succeeded"
}
