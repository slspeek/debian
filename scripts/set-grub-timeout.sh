#!/usr/bin/env bash
set -e

# The first argument is the new timeout, defaults to 1
NEW_TIMEOUT=${1:-1}

sed -i -e "s/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=$NEW_TIMEOUT/" /etc/default/grub

update-grub