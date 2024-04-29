#!/usr/bin/env bash
# set -e

PACKAGE_LIST=$1

echo Package list $PACKAGE_LIST

TARGET_DIR=build/install-scripts

INSTALL_SCRIPT=${TARGET_DIR}/install-lst-$(basename $PACKAGE_LIST).sh

cat > $INSTALL_SCRIPT << 'EOF'
OPTION=$1
if [ "$OPTION" = "-r" ]; then
   SUBCMD=remove
elif [ "$OPTION" = "-p" ]; then
   SUBCMD=purge
else
   SUBCMD=install
fi

sudo apt-get $SUBCMD -y \
EOF
(for PACKAGE in $(cat ${PACKAGE_LIST}|tr '\n' ' ')
do 
    echo "    " $PACKAGE " \\"
done; echo) >> $INSTALL_SCRIPT