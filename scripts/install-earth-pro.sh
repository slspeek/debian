#!/bin/bash

sudo wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb -P /tmp
sudo apt-get install --yes /tmp/google-earth-stable*.deb