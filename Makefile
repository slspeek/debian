
SHELL=/bin/bash

all: scripts preseed cursus

clean:
	rm -rf build

prepare: check_package_file_endings check_script_file_endings
	mkdir -p build/install-scripts
	cp website/index.html build

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
	rm -rf install-scripts
	gzip scripts.tar

.ONESHELL:
preseed: prepare scripts
	./interpolate-preseed.sh -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,dutch-desktop,docker -o build/preseed.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial

cursus:
	./interpolate-preseed.sh -u $$(cat default-user) -p essential-cli-tools,desktop,dutch-desktop -o build/cursus.cfg -t gnome -c prepare-education-box,tmux-conf,no-gnome-initial



.ONESHELL:
check_package_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		./check-newline.sh $${FILE}
	done
	
.ONESHELL:
check_script_file_endings:
	@for FILE in $(shell ls late-cmds/*)
	do
		./check-newline.sh $${FILE}
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