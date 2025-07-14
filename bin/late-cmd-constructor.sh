#!/usr/bin/env bash
set -e

LATE_CMDS=$1
LATE_CMD_LOGGING_DIR=$2
PRESEED_NAME=$3
GH_PAGES=$4

SCRIPTS_TMPFILE=$(mktemp)
# echo foo
COMMAND="LATE_CMD_LOGGING_DIR=$LATE_CMD_LOGGING_DIR LATE_CMD_SRC=/usr/local/bin/late-cmds.sh /usr/local/bin/late-cmd-helper.sh ${LATE_CMDS//,/ }"
echo "$COMMAND" ">" "$LATE_CMD_LOGGING_DIR/late-cmd.log 2>&1" "&& \\"   >> $SCRIPTS_TMPFILE
CMDS=$(cat $SCRIPTS_TMPFILE)

cat - << EOF
/bin/sh -c ' \\
wget --directory-prefix=/tmp --no-verbose $GH_PAGES/scripts.tar.gz && \\
tar -C /usr/local/bin -xzf /tmp/scripts.tar.gz && \\
/usr/local/bin/download-preseed.sh $GH_PAGES $PRESEED_NAME && \\
mkdir -p $LATE_CMD_LOGGING_DIR/failed && \\
$CMDS
/usr/local/bin/console-large-font.sh && \\
apt-get remove -y kdeconnect'
EOF
