#!/usr/bin/env bash
set -e

patch /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
--- /etc/apt/apt.conf.d/50unattended-upgrades	2022-12-31 21:59:00.000000000 +0100
+++ 50unattended-upgrades	2024-02-21 12:18:46.727808863 +0100
@@ -40,6 +40,12 @@
 //      "o=Debian,a=stable-updates";
 //      "o=Debian,a=proposed-updates";
 //      "o=Debian Backports,a=${distro_codename}-backports,l=Debian Backports";
+	
+	// Google Chrome
+	"o=Google LLC,a=stable";
+
+	// Visual Studio Code
+	"o=code stable,a=stable";
 };
 
 // Python regular expressions, matching packages to exclude from upgrading
EOF
