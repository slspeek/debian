#!/bin/bash
PATCH=$(mktemp)
cat << 'EOF' > $PATCH
--- /etc/apt/apt.conf.d/50unattended-upgrades	2022-12-31 21:59:00.000000000 +0100
+++ 50unattended-upgrades	2024-02-20 13:16:11.805202900 +0100
@@ -40,6 +40,9 @@
 //      "o=Debian,a=stable-updates";
 //      "o=Debian,a=proposed-updates";
 //      "o=Debian Backports,a=${distro_codename}-backports,l=Debian Backports";
+
+	// For updating Google Chrome
+	"o=Google LLC,a=stable";
 };
 
 // Python regular expressions, matching packages to exclude from upgrading
EOF
sudo patch /etc/apt/apt.conf.d/50unattended-upgrades $PATCH
