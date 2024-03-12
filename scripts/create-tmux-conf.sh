#!/usr/bin/env bash

cat > $HOME/.tmux.conf <<EOF
# ~/.tmux.conf

unbind-key C-b

set-option -g prefix C-a

bind-key C-a send-prefix
EOF