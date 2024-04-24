#!/usr/bin/env bash
set -e
set -x

cat > $HOME/.tmux.conf <<EOF
# ~/.tmux.conf

unbind-key C-b

set-option -g prefix C-a

bind-key C-a send-prefix
EOF