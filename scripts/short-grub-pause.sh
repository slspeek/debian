#!/usr/bin/env bash
set -e

patch /etc/default/grub << 'EOF'
--- grub.bak	2024-04-15 15:55:27.343219877 +0200
+++ grub	2024-04-15 15:56:11.355087286 +0200
@@ -4,7 +4,7 @@
 #   info -f grub -n 'Simple configuration'
 
 GRUB_DEFAULT=0
-GRUB_TIMEOUT=5
+GRUB_TIMEOUT=1
 GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
 GRUB_CMDLINE_LINUX_DEFAULT="quiet"
 GRUB_CMDLINE_LINUX=""
EOF

update-grub