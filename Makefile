SHELL=/bin/bash
export PATH:=$(PWD)/bin:$(PATH)

USER_ID=$(shell id -u):$(shell id -g)


PANDOC_IMAGE=pandoc/latex:2.9
PANDOC_HTML_CMD=docker run --rm --init -v "$(PWD):/data" -u $(USER_ID) $(PANDOC_IMAGE) --standalone --from markdown --to html

BATS_IMAGE=bats/bats:v1.10.0
BATS_CMD=docker run -i --rm --init -v "$(PWD):/code" -u $(USER_ID) $(BATS_IMAGE)

LATE_CMD_LOGGING_DIR=/var/log/installer-preseed/late-cmd
MINIMAL_PACKAGE_LISTS=essential-cli-tools,$\
	desktop,$\
	desktop-extra,$\
	dutch-desktop,$\
	multimedia
ALL_PACKAGE_LISTS=$(MINIMAL_PACKAGE_LISTS),$\
	cli-tools,$\
	developer,$\
	docker,$\
	firewall,$\
	games,$\
	graphic,$\
	libreoffice-application,$\
	machine-label,$\
	odbinfo,$\
	printing,$\
	upgrades,$\
	video-editing,$\
	virusscanner,$\
	virtmanager
MINIMAL_LIVE_LATE_CMDS=firefox-extensions,$\
	error-prompt,$\
	tmux-conf
MINIMAL_LATE_CMDS=$(MINIMAL_LIVE_LATE_CMDS),$\
	chrome-remote-desktop,$\
	earth-pro,$\
	gnome-customizations,$\
	google-chrome,$\
	no-gnome-initial,$\
	shortcuts,$\
	short-grub-pause,$\
	sudo-nopasswd
COMPLETE_LIVE_LATE_CMDS=$(MINIMAL_LIVE_LATE_CMDS),$\
	chrome-remote-desktop,$\
	dotnet,$\
	earth-pro,$\
	gists,$\
	golang,$\
	google-chrome,$\
	popcorntime,$\
	vscode
COMPLETE_LATE_CMDS=$(MINIMAL_LATE_CMDS),$\
	docker,$\
	dotnet,$\
	gists,$\
	golang,$\
	megasync,$\
	prepare-education-box,$\
	popcorntime,$\
	uu-add-origins,$\
	uu-activate,$\
	vscode
INTERPOLATION_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) interpolate-preseed.sh
LIVE_BUILD_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) live-build.sh
DEFAULT_USER=$(shell cat default-user)

default: clean all

all: precommit scripts preseeds validate_preseeds lives website

preseeds: gnome\
	cursus\
	tutor\
	server\
	gnome_complete\
	gnome_complete_personal\
	lxde\
	lxde_personal\
	lxde_complete_personal\
	steven\
	gnome_personal\
	mate\
	mate_personal\
	mate_complete\
	mate_complete_personal

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

validate: bash_tests \
	check_package_file_endings \
	check_latecmd_file_endings \
	check_preseed_fragment_file_endings 

bash_tests: 
	$(BATS_CMD) /code/test

.ONESHELL:
scripts: prepare generate_install_scripts generate_late_cmd_script
	cd scripts
	chmod +x *.sh *.py
	tar cf ../build/scripts.tar --owner=0 --group=0 *.sh *.py
	cd ..
	cd build/install-scripts
	chmod +x *.sh
	tar rf ../scripts.tar --owner=0 --group=0 *.sh
	cd ..
	rm -rf install-scripts
	chmod +x late-cmds.sh
	tar rf scripts.tar late-cmds.sh --owner=0 --group=0
	gzip scripts.tar

gnome: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p $(MINIMAL_PACKAGE_LISTS) -o build/gnome.cfg -t gnome -c $(MINIMAL_LATE_CMDS),shortcuts

gnome_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(MINIMAL_PACKAGE_LISTS) -o build/gnome-personal.cfg -t gnome -c $(MINIMAL_LATE_CMDS),shortcuts

mate: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p $(MINIMAL_PACKAGE_LISTS) -o build/mate.cfg -t mate -c $(MINIMAL_LATE_CMDS)

mate_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(MINIMAL_PACKAGE_LISTS) -o build/mate-personal.cfg -t mate -c  $(MINIMAL_LATE_CMDS)

cursus: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p essential-cli-tools,desktop,dutch-desktop -o build/cursus.cfg -t gnome -c prepare-education-box,error-prompt,short-grub-pause,tmux-conf,no-gnome-initial

tutor: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p essential-cli-tools,cli-tools,desktop,developer,docker,dutch-desktop,video-editing -o build/tutor.cfg -t gnome -c error-prompt,gists,prepare-education-box,tmux-conf,no-gnome-initial,short-grub-pause,vscode,docker

server: prepare
	$(INTERPOLATION_CMD) -r -u $(DEFAULT_USER) -p essential-cli-tools,cli-tools,developer,docker,server -o build/server.cfg -t standard -c error-prompt,short-grub-pause,sudo-nopasswd,tmux-conf,docker

gnome_complete: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p $(ALL_PACKAGE_LISTS) -o build/gnome-complete.cfg -t gnome -c $(COMPLETE_LATE_CMDS),shortcuts

mate_complete: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p $(ALL_PACKAGE_LISTS) -o build/mate-complete.cfg -t mate -c $(COMPLETE_LATE_CMDS)

gnome_complete_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(ALL_PACKAGE_LISTS) -o build/gnome-complete-personal.cfg -t gnome -c $(COMPLETE_LATE_CMDS)

mate_complete_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(ALL_PACKAGE_LISTS) -o build/mate-complete-personal.cfg -t mate -c $(COMPLETE_LATE_CMDS)

lxde: prepare
	$(INTERPOLATION_CMD) -u $(DEFAULT_USER) -p $(MINIMAL_PACKAGE_LISTS) -o build/lxde.cfg -t lxde -c $(MINIMAL_LATE_CMDS)

lxde_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(MINIMAL_PACKAGE_LISTS) -o build/lxde-personal.cfg -t lxde -c  $(MINIMAL_LATE_CMDS)

lxde_complete_personal: prepare
	$(INTERPOLATION_CMD) -a -p $(ALL_PACKAGE_LISTS) -o build/lxde-complete-personal.cfg -t lxde -c $(COMPLETE_LATE_CMDS)

steven: prepare
	$(INTERPOLATION_CMD) -r -u steven -p $(ALL_PACKAGE_LISTS) -o build/steven.cfg -t gnome -c $(COMPLETE_LATE_CMDS),shortcuts

live_server: prepare
	$(LIVE_BUILD_CMD) -u $(DEFAULT_USER) -p essential-cli-tools -n server -t standard -c error-prompt,golang,gists,tmux-conf

live_gnome_complete: prepare
	$(LIVE_BUILD_CMD) -u $(DEFAULT_USER) -p $(ALL_PACKAGE_LISTS) -n gnome-complete -t gnome \
	-c $(COMPLETE_LIVE_LATE_CMDS)

live_gnome: prepare
	$(LIVE_BUILD_CMD) -u $(DEFAULT_USER) -p $(MINIMAL_PACKAGE_LISTS) -n gnome -t gnome -c $(MINIMAL_LIVE_LATE_CMDS)

live_mate: prepare
	$(LIVE_BUILD_CMD) -u $(DEFAULT_USER) -p $(MINIMAL_PACKAGE_LISTS) -n mate -t mate -c $(MINIMAL_LIVE_LATE_CMDS)

live_mate_complete: prepare
	$(LIVE_BUILD_CMD) -u $(DEFAULT_USER) -p $(ALL_PACKAGE_LISTS) -n mate-complete -t mate \
	-c $(COMPLETE_LIVE_LATE_CMDS)

lives: live_server\
	live_gnome_complete\
	live_gnome live_mate\
	live_mate_complete

.ONESHELL:
validate_preseeds:
	@for FILE in $(wildcard build/*.cfg)
	do
		 test $$(debconf-set-selections --checkonly $${FILE} 2>&1 |grep 'warning:'|wc -l) -eq 0 || \
		 (echo $${FILE} is not a valid preseed file:;debconf-set-selections --checkonly $${FILE}; exit 1)
	done

.ONESHELL:
check_package_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		check-newline.sh $${FILE} || exit 1
	done
	
.ONESHELL:
check_latecmd_file_endings:
	@for FILE in $(shell ls late-cmds/*)
	do
		check-newline.sh $${FILE} || exit 1
	done

.ONESHELL:
check_preseed_fragment_file_endings:
	@for FILE in $(shell ls preseed.cfg.d/*)
	do
		check-newline.sh $${FILE} || exit 1
	done

generate_install_scripts: prepare
	@for FILE in $(shell ls package-lists/*)
	do
		echo $${FILE}
		generate-install-script.sh $${FILE} || exit 1
	done

website: prepare
	$(PANDOC_HTML_CMD) --metadata title="Nederlandse Debian preseeds en live-build configuraties" website/index.md -o build/index.html
	
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