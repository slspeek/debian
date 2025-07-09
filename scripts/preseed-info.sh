#!/usr/bin/env bash

grep '^##' /var/log/installer-preseed/profile.cfg|cut -c 4-
echo
echo Logs:
echo -----
cat /var/log/installer-preseed/late-cmd/late-cmd.log
