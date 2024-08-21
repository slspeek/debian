#!/usr/bin/env bash
set -e

download-gists.sh 

EXTENSTION_URLS=( \
    "https://addons.mozilla.org/firefox/downloads/file/4326974/adblock_for_youtube-0.4.8.xpi" \
    "https://addons.mozilla.org/firefox/downloads/file/4202634/i_dont_care_about_cookies-3.5.0.xpi" \
    "https://addons.mozilla.org/firefox/downloads/file/4320550/adblocker_ultimate-3.8.26.xpi" \
)

TEMPDIR=$(mktemp -d)
cd $TEMPDIR
for i in "${EXTENSTION_URLS[@]}"
do
   wget --no-verbose "$i"
   install-mozilla-extension-globally.sh $(basename "$i")
   # or do whatever with individual element of the array
done

wget --no-verbose "https://web.archive.org/web/20231126113521id_/https://addons.mozilla.org/firefox/downloads/file/3857142/archive_page-0.6.0.xpi"

mv archive_page_0.6.0.xpi /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/\{5b22cb75-8e43-4f2a-bb9b-1da0655ae564\}.xpi
