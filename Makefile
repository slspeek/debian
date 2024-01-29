
SHELL=/bin/bash

clean:
	rm -rf build

prepare: check_package_file_endings check_script_file_endings
	mkdir -p build/install-scripts

.ONESHELL:
scripts: prepare generate_install_scripts
	cd scripts
	chmod +x *.sh
	tar cf ../build/scripts.tar *.sh
	cd ..
	cd build/install-scripts
	chmod +x *.sh
	tar rf ../scripts.tar *.sh
	cd ..
	gzip scripts.tar

.ONESHELL:
preseed: prepare scripts
	./interpolate-preseed.sh -p essential-cli-tools,cli-tools,desktop,dutch-desktop,docker -o build/preseed.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial

.ONESHELL:
check_package_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		echo -n $${FILE} " ";test $$(tail -c 1 $${FILE} | wc -l) -eq 1; if test "$$?" -eq "0"; then echo OK; else echo No newline at the end of the file; exit 1; fi
	done
	
.ONESHELL:
check_script_file_endings:
	@for FILE in $(shell ls late-cmds/*)
	do
		echo -n $${FILE} " ";test $$(tail -c 1 $${FILE} | wc -l) -eq 1; if test "$$?" -eq "0"; then echo OK; else echo No newline at the end of the file; exit 1; fi
	done

generate_install_scripts: prepare
	@for FILE in $(shell ls package-lists/*)
	do
		(echo '#!/bin/bash'; echo; echo "sudo apt-get install -y  \\"; \
		for PACKAGE in $$(cat $${FILE}|tr '\n' ' ')
		do 
			echo "    " $${PACKAGE} " \\"
		done ; echo ) > build/install-scripts/install-$$(basename $${FILE}).sh
	done