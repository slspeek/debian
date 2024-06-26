#!/usr/bin/env bash
set -e

BACKUP_NAME=$1
BACKUP_USER=$2
BACKUP_HOST=$3
BACKUP_DIR=$4

TIMESTAMP=$(date +%Y%m%d)
DEFAULT_TARGETDIR=/home/${BACKUP_USER}/${BACKUP_NAME}-backup-${TIMESTAMP}/
TARGETDIR=${4:-$DEFAULT_TARGETDIR}

if [ -z "$BACKUP_DIR" ]; then
    ssh -l $BACKUP_USER $BACKUP_HOST mkdir -p $TARGETDIR
fi
RSYNC_CMD="rsync -ar --delete -v" 
$RSYNC_CMD /home /root /etc ${BACKUP_USER}@${BACKUP_HOST}:${TARGETDIR}

