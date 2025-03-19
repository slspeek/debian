#!/usr/bin/env bash
set -e

curl -fsS -o- https://deb.packages.mattermost.com/setup-repo.sh | bash

DEBIAN_FRONTEND=noninteractive apt-get install --yes mattermost-desktop