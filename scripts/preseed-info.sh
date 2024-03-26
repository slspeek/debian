#!/usr/bin/env bash

head -14 /var/log/installer-preseed/profile.cfg|tail -12|cut -c 4-
echo
echo Logs:
echo -----
cat /var/log/installer-preseed/late-cmd/late-cmd.log
