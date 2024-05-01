#!/usr/bin/env bash
set -e

BACKUP_NAME=$1
BACKUP_HOST=$2
BACKUP_DIR=$3

TIMESTAMP=$(date +%Y%m%d-%H%M)
DEFAULT_TARGETDIR=/home/${BACKUP_NAME}-backup-${TIMESTAMP}/
TARGETDIR=${3:-$DEFAULT_TARGETDIR}

ssh $BACKUP_HOST mkdir -p $TARGETDIR
RSYNC_CMD="rsync -ar --delete -v" 
$RSYNC_CMD /home /root /etc $BACKUP_HOST:$TARGETDIR

