#!/usr/bin/env bats

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/..:$DIR/../bin:$PATH"
}

@test "Good scenario" {

TMP_FILE=$(mktemp)
cat > $TMP_FILE << EOF
aap
noot
mies
EOF
check-newline.sh $TMP_FILE


}

@test "Should fail scenario" {

TMP_FILE=$(mktemp)
echo -n aap > $TMP_FILE
! check-newline.sh $TMP_FILE


}