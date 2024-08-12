#!/usr/bin/env bash

dpkg --add-architecture i386
apt-get update
apt-get install -y steamcmd