#!/usr/bin/env bash
set -e

if [ "$(id -u)" -eq 0 ]; then
    $HOME=/root
fi

cat > $HOME/.tmux.conf <<EOF
# ~/.tmux.conf

unbind-key C-b

set-option -g prefix C-a

bind-key C-a send-prefix
EOF