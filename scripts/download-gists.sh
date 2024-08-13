#!/usr/bin/env bash
set -e

GITHUB_GISTS=https://gist.githubusercontent.com/slspeek/

function get_gist() {
    SCRIPT=$1
    HASH=$2
    sudo wget --no-verbose ${GITHUB_GISTS}/$HASH/raw/$SCRIPT -P /usr/local/bin
    sudo chmod +x /usr/local/bin/$SCRIPT
}

get_gist create-tag.sh 400f682d448e20782d768130f6229f82

get_gist cleanup-tags.sh 59155b166cfe78ae16a1862128225b69

get_gist install-mozilla-extension-globally.sh 3e9a5d9cac7af001ee606987c449f10f