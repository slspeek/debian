#!/usr/bin/env bash

function chrome-remote-desktop ()
{
   install-chrome-remote-desktop.sh
}

function dart ()
{
   install-dart.sh
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

function element ()
{
   install-element.sh
}

function error-prompt ()
{
   set-error-prompt.sh
}

function firefox-extensions ()
{
   install-firefox-extensions.sh
}

function gists ()
{
   download-gists.sh
}

function gnome-customizations ()
{
   sudo -u $(id -nu 1000) /bin/sh -c 'dbus-run-session -- gnome-customizations.sh'
}

function golang ()
{
   install-golang.sh
}

function google-chrome ()
{
   install-google-chrome.sh
}

function megasync ()
{
   install-megasync.sh
}

function netselect-apt ()
{
   run-netselect-apt.sh
}

function no-gnome-initial ()
{
   disable-gnome-initial-setup.sh $(id -nu 1000)
}

function popcorntime ()
{
   install-popcorntime.sh
  
}

function prepare-education-box ()
{
   cd /usr/local/bin && wget https://github.com/slspeek/linux-beginners-cursus/releases/latest/download/prepare-education-box.sh && chmod +x prepare-education-box.sh
}

function raspberry-pi-imager ()
{
   install-raspberry-pi-imager.sh
}

function short-grub-pause ()
{
   short-grub-pause.sh
}

function shortcuts ()
{
   sudo -u $(id -nu 1000) /bin/sh -c 'dbus-run-session -- set-shortcuts.sh'
}

function sudo-nopasswd ()
{
   sudo-nopasswd.sh $(id -nu 1000)
}

function teamviewer ()
{
   install-teamviewer.sh
}

function tmux-conf ()
{
   create-tmux-conf.sh ; sudo -u $(id -nu 1000) /bin/sh -c 'cp /etc/skel/.tmux.conf ~' ; cp /etc/skel/.tmux.conf /root
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

function workrave ()
{
   autostart-workrave.sh
}

