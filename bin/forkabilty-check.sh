#!/usr/bin/env bash
set -e

USER_NAME=$1
REPO_NAME=$2

rg $USER_NAME.github.io/$REPO_NAME\|github.com/$USER_NAME/$REPO_NAME
