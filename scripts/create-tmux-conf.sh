#!/usr/bin/env bash
set -e

cat > /etc/skel/.tmux.conf <<EOF
# ~/.tmux.conf

unbind-key C-b

set-option -g prefix C-a

bind-key C-a send-prefix
EOF