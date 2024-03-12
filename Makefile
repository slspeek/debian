SHELL=/bin/bash

USER_ID=$(shell id -u):$(shell id -g)

PANDOC_IMAGE=pandoc/latex:2.9
PANDOC_HTML_CMD=docker run --rm --init -v "$(PWD):/data" -u $(USER_ID) $(PANDOC_IMAGE) --standalone --from markdown --to html

BATS_IMAGE=bats/bats:v1.10.0
BATS_CMD=docker run -i --rm --init -v "$(PWD):/code" -u $(USER_ID) $(BATS_IMAGE)

LATE_CMD_LOGGING_DIR=/var/log/installer-preseed/late-cmd
ALL_PACKAGES=essential-cli-tools,cli-tools,desktop,desktop-extra,developer,dutch-desktop,docker,graphic,multimedia,upgrades,video-editing
COMPLETE_LATE_CMDS=auto-set-shortcuts,sudo-nopasswd,chrome-remote-desktop,docker,earth-pro,gists,golang,google-chrome,prepare-education-box,uu-add-origins,uu-activate,tmux-conf,no-gnome-initial,vscode
INTERPOLATION_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) ./interpolate-preseed.sh

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

validate: bash_tests check_package_file_endings check_latecmd_file_endings check_preseed_fragment_file_endings 

bash_tests: 
	$(BATS_CMD) /code/test

.ONESHELL:
scripts: prepare generate_install_scripts generate_late_cmd_script
	cd scripts
	chmod +x *.sh *.py
	tar cf ../build/scripts.tar *.sh *.py
	cd ..
	cd build/install-scripts
	chmod +x *.sh
	tar rf ../scripts.tar *.sh
	cd ..
	rm -rf install-scripts
	chmod +x late-cmds.sh
	tar rf scripts.tar late-cmds.sh || exit 1
	gzip scripts.tar

gnome: prepare
	$(INTERPOLATION_CMD) -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,desktop-extra,dutch-desktop,docker -o build/gnome.cfg -t gnome -c sudo-nopasswd,chrome-remote-desktop,docker,earth-pro,google-chrome,tmux-conf,no-gnome-initial

cursus: prepare
	$(INTERPOLATION_CMD) -u $$(cat default-user) -p essential-cli-tools,desktop,dutch-desktop -o build/cursus.cfg -t gnome -c prepare-education-box,tmux-conf,no-gnome-initial

tutor: prepare
	$(INTERPOLATION_CMD) -u $$(cat default-user) -p essential-cli-tools,cli-tools,desktop,developer,docker,dutch-desktop,video-editing -o build/tutor.cfg -t gnome -c gists,prepare-education-box,tmux-conf,no-gnome-initial,vscode,docker

server: prepare
	$(INTERPOLATION_CMD) -r -u $$(cat default-user) -p essential-cli-tools,cli-tools,developer,docker -o build/server.cfg -t standard -c sudo-nopasswd,tmux-conf,docker

complete: prepare
	$(INTERPOLATION_CMD) -u $$(cat default-user) -p $(ALL_PACKAGES) -o build/complete.cfg -t gnome -c $(COMPLETE_LATE_CMDS)

personal: prepare
	$(INTERPOLATION_CMD) -a -p $(ALL_PACKAGES) -o build/personal.cfg -t gnome -c $(COMPLETE_LATE_CMDS)

steven: prepare
	$(INTERPOLATION_CMD) -r -u steven -p $(ALL_PACKAGES) -o build/steven.cfg -t gnome -c $(COMPLETE_LATE_CMDS)

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
		(echo '#!/usr/bin/env bash'; echo; echo "sudo apt-get install -y  \\"; \
		for PACKAGE in $$(cat $${FILE}|tr '\n' ' ')
		do 
			echo "    " $${PACKAGE} " \\"
		done ; echo ) > build/install-scripts/install-$$(basename $${FILE}).sh
	done

website: prepare
	$(PANDOC_HTML_CMD) --metadata title="Nederlandse Debian preseeds" website/index.md -o build/index.html
	
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

.ONESHELL:
generate_late_cmd_script:
	LATE_CMD_SCRIPT=build/late-cmds.sh
	(echo '#!/usr/bin/env bash'; echo) > $${LATE_CMD_SCRIPT}
	for LATE_CMD in $$(ls late-cmds);
	do
		(echo function $${LATE_CMD} '()';
		echo '{';
		while read LINE
		do
			echo '  ' $${LINE}
		done < late-cmds/$${LATE_CMD} ;
		echo '}'; echo ) >> $${LATE_CMD_SCRIPT} 
	done