#!/usr/bin/env bash

function chrome-remote-desktop ()
{
   install-chrome-remote-desktop.sh
}

function docker ()
{
   adduser $(id -nu 1000) docker
}

function dotnet ()
{
   install-dotnet.sh
}

function earth-pro ()
{
   install-earth-pro.sh
}

function error-prompt ()
{
   set-error-prompt.sh
}

function gists ()
{
   download-gists.sh
}

function golang ()
{
   install-golang.sh
}

function google-chrome ()
{
   install-google-chrome.sh
}

function no-gnome-initial ()
{
   disable-gnome-initial-setup.sh $(id -nu 1000)
}

function prepare-education-box ()
{
   cd /usr/local/bin && wget https://raw.githubusercontent.com/slspeek/linux-beginners-cursus/main/bin/prepare-education-box.sh && chmod +x prepare-education-box.sh
}

function short-grub-pause ()
{
   short-grub-pause.sh
}

function sudo-nopasswd ()
{
   sudo-nopasswd.sh $(id -nu 1000)
}

function tmux-conf ()
{
   sudo -u $(id -nu 1000) create-tmux-conf.sh && create-tmux-conf.sh
}

function uu-activate ()
{
   echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections && dpkg-reconfigure -f noninteractive unattended-upgrades
}

function uu-add-origins ()
{
   uu-add-origins.sh
}

function vscode ()
{
   install-vscode.sh
}
