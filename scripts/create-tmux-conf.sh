#!/usr/bin/env bash
set -e
set -x
echo Running as $USER with homedir $HOME >&2

cat > $HOME/.tmux.conf <<EOF
# ~/.tmux.conf

unbind-key C-b

set-option -g prefix C-a

bind-key C-a send-prefix
EOF