#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../bin:$PATH"

    export PACKAGE_LIST_LOCATION=$(mktemp -d)
#     cat > $LATE_CMD_SRC_TMP << EOF
# function success() {
#     echo success
#     true
# }

# function failure() {
#     echo failure
#     false
# }

# EOF
   
#     export LATE_CMD_SRC=$LATE_CMD_SRC_TMP
}


@test "Environment" {
    run merge-packages.sh
    [ "$status" -eq 0 ]
    # echo PLL: $PACKAGE_LIST_LOCATION
    # echo Output: $output
    [ "${lines[0]}" = "$PACKAGE_LIST_LOCATION" ]
}

