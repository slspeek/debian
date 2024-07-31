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

cat > $PACKAGE_LIST_LOCATION/foo << EOF
wget
kstars
task-gnome-desktop
EOF

cat > $PACKAGE_LIST_LOCATION/bar << EOF
vim
tree
EOF

cat > $PACKAGE_LIST_LOCATION/foobar << EOF
wget
kstars
task-gnome-desktop
tmux
EOF
}

@test "Sorting and uniqueness" {
    run merge-packages.sh foo,bar,foobar
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "kstars" ]
    [ "${lines[1]}" = "task-gnome-desktop" ]
    [ "${lines[2]}" = "tmux" ]
    [ "${lines[3]}" = "tree" ]
    [ "${lines[4]}" = "vim" ]
    [ "${lines[5]}" = "wget" ]
}

