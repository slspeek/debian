#!/usr/bin/env bash
set -e

download-gists.sh 

EXTENSTION_URLS=( \
    "https://addons.mozilla.org/firefox/downloads/file/4326974/adblock_for_youtube-0.4.8.xpi" \
    "https://addons.mozilla.org/firefox/downloads/file/4202634/i_dont_care_about_cookies-3.5.0.xpi" \
    "https://addons.mozilla.org/firefox/downloads/file/4320550/adblocker_ultimate-3.8.26.xpi" \
    "https://addons.mozilla.org/firefox/downloads/file/4369934/archive_page-0.9.0.xpi" \
)

TEMPDIR=$(mktemp -d)
cd $TEMPDIR
for i in "${EXTENSTION_URLS[@]}"
do
   wget --no-verbose "$i"
   install-mozilla-extension-globally.sh $(basename "$i")
done