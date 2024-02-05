SHELL=/bin/bash

PANDOC_IMAGE=pandoc/latex:2.9
USER_ID=$(shell id -u):$(shell id -g)
PANDOC_HTML_CMD=docker run --rm --init -v "$(PWD):/data" -u $(USER_ID) $(PANDOC_IMAGE) --standalone --from markdown --to html

default: clean all

all: precommit scripts preseeds validate_preseeds website

preseeds: gnome cursus tutor server complete personal steven

clean:
	rm -rf build

prepare: validate
	mkdir -p build/install-scripts
	if ! which boxes; then
		sudo apt-get install -y boxes
	fi
	if ! which debconf-set-selections; then
		sudo apt-get install -y debconf-utils
	fi

validate: check_package_file_endings check_latecmd_file_endings check_preseed_fragment_file_endings 

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


gnome: prepare
	./interpolate-preseed.sh -r -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,dutch-desktop,docker -o build/gnome.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial

cursus: prepare
	./interpolate-preseed.sh -u $$(cat default-user) -p essential-cli-tools,desktop,dutch-desktop -o build/cursus.cfg -t gnome -c prepare-education-box,tmux-conf,no-gnome-initial

tutor: prepare
	./interpolate-preseed.sh -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,developer,docker,dutch-desktop,video-editing -o build/tutor.cfg -t gnome -c prepare-education-box,tmux-conf,no-gnome-initial,vscode,docker

server: prepare
	./interpolate-preseed.sh -r -u $$(cat default-user) -p essential-cli-tools -o build/server.cfg -t standard -c sudo-nopasswd,tmux-conf

complete: prepare
	./interpolate-preseed.sh -r -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,developer,dutch-desktop,docker,video-editing -o build/complete.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial,vscode

personal: prepare
	./interpolate-preseed.sh -r -a -p essential-cli-tools,cli-tools,desktop,developer,dutch-desktop,docker,video-editing -o build/personal.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial,vscode

steven: prepare
	./interpolate-preseed.sh -r -u steven -p essential-cli-tools,cli-tools,desktop,developer,dutch-desktop,docker,video-editing -o build/steven.cfg -t gnome -c sudo-nopasswd,prepare-education-box,docker,google-chrome,tmux-conf,no-gnome-initial,vscode

.ONESHELL:
validate_preseeds:
	@for FILE in $(wildcard build/*.cfg)
	do
		 test $$(debconf-set-selections --checkonly $${FILE} 2>&1 |grep 'warning:'|wc -l) -eq 0 ||(echo $${FILE} is not a valid preseed file:;debconf-set-selections --checkonly $${FILE}; exit 1)
	done

.ONESHELL:
check_package_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		./check-newline.sh $${FILE} || exit 1
	done
	
.ONESHELL:
check_latecmd_file_endings:
	@for FILE in $(shell ls late-cmds/*)
	do
		./check-newline.sh $${FILE} || exit 1
	done

.ONESHELL:
check_preseed_fragment_file_endings:
	@for FILE in $(shell ls preseed.cfg.d/*)
	do
		./check-newline.sh $${FILE} || exit 1
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
	
precommit: sort_package_lists

sort_package_lists:
	@for LIST in $$(ls package-lists/*)
	do
		sed -i -e '/^$$/d' $${LIST}
		sort -o $${LIST} $${LIST}
		echo >> $${LIST}
		sed -i -e '/^$$/d' $${LIST}
	done

.ONESHELL:
check_package_names:
	while read PACKAGE_NAME
	do
		apt-cache show $${PACKAGE_NAME} &> /dev/null || (echo Problem with: $${PACKAGE_NAME}; exit 1)
	done <<< $$(cat package-lists/*)
