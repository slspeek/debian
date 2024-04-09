#!/usr/bin/env bash

function auto-set-shortcuts ()
{
   /bin/sh -c '/usr/local/bin/auto-set-shortcuts.sh $(id -nu 1000)'
}

function chrome-remote-desktop ()
{
   /usr/local/bin/install-chrome-remote-desktop.sh
}

function color-prompt ()
{
   /usr/local/bin/install-color-prompt.sh
   /bin/sh -c '/usr/local/bin/set-color-prompt.sh $(id -nu 1000)'
}

function docker ()
{
   /bin/sh -c 'adduser $(id -nu 1000) docker'
}

function earth-pro ()
{
   /usr/local/bin/install-earth-pro.sh
}

function gists ()
{
   /usr/local/bin/download-gists.sh
}

function golang ()
{
   /usr/local/bin/install-golang.sh
}

function google-chrome ()
{
   /usr/local/bin/install-google-chrome.sh
}

function no-gnome-initial ()
{
   /bin/sh -c '/usr/local/bin/disable-gnome-initial-setup.sh $(id -nu 1000)'
}

function prepare-education-box ()
{
   /bin/sh -c 'cd /usr/local/bin && wget https://raw.githubusercontent.com/slspeek/linux-beginners-cursus/main/bin/prepare-education-box.sh && chmod +x prepare-education-box.sh'
}

function sudo-nopasswd ()
{
   /bin/sh -c '/usr/local/bin/sudo-nopasswd.sh $(id -nu 1000)'
}

function tmux-conf ()
{
   /bin/sh -c 'sudo -u $(id -nu 1000) /usr/local/bin/create-tmux-conf.sh' && /usr/local/bin/create-tmux-conf.sh
}

function uu-activate ()
{
   /bin/sh -c 'echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections' && dpkg-reconfigure -f noninteractive unattended-upgrades
}

function uu-add-origins ()
{
   /usr/local/bin/uu-add-origins.sh
}

function vscode ()
{
   /usr/local/bin/install-vscode.sh
}

