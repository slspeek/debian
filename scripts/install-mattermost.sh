#!/usr/bin/env bash
set -e

apt-get install -qq --yes extrepo
sed -i -e '/- non-free/ s/^# //' /etc/extrepo/config.yaml
sed -i -e '/- contrib/ s/^# //' /etc/extrepo/config.yaml
extrepo enable mattermost
apt-get -qq update || true # ignore cdrom entry that is not yet disabled during the late-cmd execution
DEBIAN_FRONTEND=noninteractive apt-get install --yes mattermost-desktop
