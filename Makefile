SHELL=/bin/bash

PANDOC_IMAGE=pandoc/latex:2.9
USER_ID=$(shell id -u):$(shell id -g)
PANDOC_HTML_CMD=docker run --rm --init -v "$(PWD):/data" -u $(USER_ID) $(PANDOC_IMAGE) --standalone --from markdown --to html


all: scripts preseed cursus website

clean:
	rm -rf build

prepare: check_package_file_endings check_script_file_endings
	mkdir -p build/install-scripts
	if ! which boxes; then
		sudo apt-get install -y boxes
	fi
	# cp website/index.html build

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

website: prepare
	$(PANDOC_HTML_CMD) --metadata title="Debian preseeds" website/index.md -o build/index.html
	