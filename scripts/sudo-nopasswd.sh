#!/usr/bin/env bash
set -e

USERNAME=$1

echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME