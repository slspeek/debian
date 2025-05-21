#!/usr/bin/env bash
set -e

PRESEED_NAME=$1

PRESEED_LOG_DIR=installer-preseed
cd /var/log/ 
if [ -d $PRESEED_LOG_DIR ];
then 
  mv -v $PRESEED_LOG_DIR ${PRESEED_LOG_DIR}.live
fi
mkdir $PRESEED_LOG_DIR
cd $PRESEED_LOG_DIR
wget --no-verbose https://slspeek.github.io/debian/$PRESEED_NAME
ln -s $PRESEED_NAME profile.cfg
