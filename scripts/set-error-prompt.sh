#!/usr/bin/env bash
set -e

patch /etc/bash.bashrc << 'EOF'
--- bash.bashrc.bak	2024-04-24 14:09:46.337096429 +0200
+++ bash.bashrc	2024-04-24 14:43:32.001427499 +0200
@@ -18,7 +18,12 @@
 # set a fancy prompt (non-color, overwrite the one in /etc/profile)
 # but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
 if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
-  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
+  if [ "$(id -u)" -eq 0 ]; then
+    PS1_BASE='\u@\h:\w'
+  else
+    PS1_BASE='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
+  fi
+  PROMPT_COMMAND='if [ $? -eq 0 ]; then PS1=$PS1_BASE\\$; else PS1=$PS1_BASE\\[\\033[01\;31m\\]\(\$?\)\*\\[\\033[00m\\]; fi; history -a'
 fi
 
 # Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
EOF
