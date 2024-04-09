#!/usr/bin/env bash
set -e

USER=${1:-`id -nu 1000`}

sudo -u $USER /bin/sh -c 'cp /etc/skel/.bashrc $HOME'