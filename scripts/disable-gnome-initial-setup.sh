#!/usr/bin/env bash

USER=$1

sudo -u $USER /bin/sh -c 'mkdir -p ~/.config && echo yes > ~/.config/gnome-initial-setup-done'