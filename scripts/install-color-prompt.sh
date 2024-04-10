#!/usr/bin/env bash
set -e

patch /etc/skel/.bashrc << 'EOF'
--- .bashrc-bak 2024-04-09 14:32:55.627712723 +0200
+++ .bashrc     2024-04-09 14:41:00.346563552 +0200
@@ -57,7 +57,9 @@
 fi
 
 if [ "$color_prompt" = yes ]; then
-    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
+    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
+    PS1_BASE='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
+    PROMPT_COMMAND='if [ $? -eq 0 ]; then PS1=$PS1_BASE\\$; else PS1=$PS1_BASE\\[\\033[01\;31m\\]\(\$?\)\*\\[\\033[00m\\]; fi; history -a'
 else
     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
 fi
EOF
