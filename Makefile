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
	dutch-desktop,$\
	multimedia
ALL_PACKAGE_LISTS=$(MINIMAL_PACKAGE_LISTS),$\
	cli-tools,$\
	desktop-extra,$\
	developer-cli,$\
	developer-desktop,$\
	docker,$\
	firewall,$\
	games,$\
	gnome-extensions,$\
	graphic,$\
	libreoffice-application,$\
	machine-label,$\
	odbinfo,$\
	printing,$\
	photography,$\
	stress-test,$\
	video-editing,$\
	virusscanner,$\
	virtmanager
MINIMAL_LIVE_LATE_CMDS=firefox-extensions,$\
	error-prompt,$\
	netselect-apt,$\
	tmux-conf
MINIMAL_LATE_CMDS=$(MINIMAL_LIVE_LATE_CMDS),$\
	chrome-remote-desktop,$\
	earth-pro,$\
	gnome-customizations,$\
	google-chrome,$\
	no-gnome-initial,$\
	shortcuts,$\
	short-grub-timeout,$\
	sudo-nopasswd
COMPLETE_LIVE_LATE_CMDS=$(MINIMAL_LIVE_LATE_CMDS),$\
	chrome-remote-desktop,$\
	dart,$\
	dotnet,$\
	earth-pro,$\
	element,$\
	gists,$\
	golang,$\
	google-chrome,$\
	mattermost,$\
	megasync,$\
	prepare-education-box,$\
	popcorntime,$\
	teamviewer,$\
	vscode
COMPLETE_LATE_CMDS=$(MINIMAL_LATE_CMDS),$\
  dart,$\
	docker,$\
	dotnet,$\
	element,$\
	gists,$\
	golang,$\
	mattermost,$\
	megasync,$\
	prepare-education-box,$\
	popcorntime,$\
	teamviewer,$\
	vscode

INTERPOLATION_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) interpolate-preseed.sh
LIVE_BUILD_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) live-build.sh
LIVE_STAGE_DIR=$(shell pwd)/live-isos
LIVE_ISO_DESTINATION=$(LIVE_STAGE_DIR)
LIVE_ISO_KEEP=
DEFAULT_USER=$(shell cat default-user)

default: clean all

all: precommit scripts preseeds validate_preseeds lives website

preseeds: gnome\
	cursus\
	tutor\
	server\
	server_personal\
	lxde\
	lxde_personal\
	lxde_complete_personal\
	gnome_complete\
	gnome_complete_personal\
	gnome_personal\
	steven\
	cinnamon\
	cinnamon_personal\
	cinnamon_complete\
	cinnamon_complete_personal\
	mate\
	mate_personal\
	mate_complete\
	mate_complete_personal

clean:
	rm -rf build

clean-isos:
	sudo rm -rf live-isos

prepare: validate
	mkdir -p build/install-scripts
	if ! which boxes; then
		sudo apt-get install -y boxes
	fi
	if ! which debconf-set-selections; then
		sudo apt-get install -y debconf-utils
	fi
	if ! which pv; then
		sudo apt-get install -y pv
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


# Preseed generation


# GNOME

gnome: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/gnome.cfg \
		-t gnome \
		-c $(MINIMAL_LATE_CMDS),shortcuts

gnome_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/gnome-personal.cfg \
		-t gnome \
		-c $(MINIMAL_LATE_CMDS),shortcuts

gnome_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/gnome-complete.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS),shortcuts

gnome_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/gnome-complete-personal.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS)

cursus: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,desktop,dutch-desktop \
		-o build/cursus.cfg \
		-t gnome \
		-c prepare-education-box,error-prompt,short-grub-timeout,tmux-conf,no-gnome-initial

tutor: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,cli-tools,desktop,developer-cli,docker,dutch-desktop,video-editing \
		-o build/tutor.cfg \
		-t gnome \
		-c error-prompt,gists,prepare-education-box,tmux-conf,no-gnome-initial,short-grub-timeout,vscode,docker

steven: prepare
	$(INTERPOLATION_CMD) \
		-r \
		-u steven \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/steven.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS),shortcuts

# KDE

kde: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/kde.cfg \
		-t kde \
		-c $(MINIMAL_LATE_CMDS)

kde_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/kde-personal.cfg \
		-t kde \
		-c  $(MINIMAL_LATE_CMDS)

kde_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/kde-complete.cfg \
		-t kde \
		-c $(COMPLETE_LATE_CMDS)

kde_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/kde-complete-personal.cfg \
		-t kde \
		-c $(COMPLETE_LATE_CMDS)

# XFCE

xfce: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/xfce.cfg \
		-t xfce \
		-c $(MINIMAL_LATE_CMDS)

xfce_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/xfce-personal.cfg \
		-t xfce \
		-c  $(MINIMAL_LATE_CMDS)

xfce_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/xfce-complete.cfg \
		-t xfce \
		-c $(COMPLETE_LATE_CMDS)

xfce_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/xfce-complete-personal.cfg \
		-t xfce \
		-c $(COMPLETE_LATE_CMDS)


# Cinnamon

cinnamon: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/cinnamon.cfg \
		-t cinnamon \
		-c $(MINIMAL_LATE_CMDS)

cinnamon_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/cinnamon-personal.cfg \
		-t cinnamon \
		-c  $(MINIMAL_LATE_CMDS)

cinnamon_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/cinnamon-complete.cfg \
		-t cinnamon \
		-c $(COMPLETE_LATE_CMDS)

cinnamon_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/cinnamon-complete-personal.cfg \
		-t cinnamon \
		-c $(COMPLETE_LATE_CMDS)

# Mate

mate: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/mate.cfg \
		-t mate \
		-c $(MINIMAL_LATE_CMDS)

mate_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/mate-personal.cfg \
		-t mate \
		-c  $(MINIMAL_LATE_CMDS)

mate_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/mate-complete.cfg \
		-t mate \
		-c $(COMPLETE_LATE_CMDS)

mate_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/mate-complete-personal.cfg \
		-t mate \
		-c $(COMPLETE_LATE_CMDS)

# LXDE

lxde: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),upgrades \
 		-o build/lxde.cfg \
		-t lxde \
		-c $(MINIMAL_LATE_CMDS),uu-add-origins,uu-activate

lxde_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS),upgrades \
		-o build/lxde-personal.cfg \
		-t lxde -c $(MINIMAL_LATE_CMDS),uu-add-origins,uu-activate

lxde_complete: prepare
	$(INTERPOLATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/lxde-complete.cfg \
		-t lxde \
		-c $(COMPLETE_LATE_CMDS)

lxde_complete_personal: prepare
	$(INTERPOLATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS),upgrades \
		-o build/lxde-complete-personal.cfg \
		-t lxde -c $(COMPLETE_LATE_CMDS),uu-add-origins,uu-activate
	
# Server

server: prepare
	$(INTERPOLATION_CMD) -r \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,cli-tools,developer-cli,docker,server \
		-o build/server.cfg \
		-t standard \
		-c error-prompt,short-grub-timeout,sudo-nopasswd,tmux-conf,docker

server_personal: prepare
	$(INTERPOLATION_CMD) \
		-r \
		-a \
		-p essential-cli-tools,cli-tools,developer-cli,docker,server \
		-o build/server-personal.cfg \
		-t standard \
		-c error-prompt,short-grub-timeout,sudo-nopasswd,tmux-conf,docker

# Live configuration generation

# GNOME

live_gnome_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n gnome-complete \
		-t gnome \
		-c $(COMPLETE_LIVE_LATE_CMDS)

live_gnome: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-n gnome \
		-t gnome \
		-c $(MINIMAL_LIVE_LATE_CMDS)

# KDE

live_kde: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-n kde \
		-t kde \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_kde_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n kde-complete \
		-t kde \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# XFCE

live_xfce: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-n xfce \
		-t xfce \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_xfce_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n xfce-complete \
		-t xfce \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Cinnamon

live_cinnamon: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-n cinnamon \
		-t cinnamon \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_cinnamon_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n cinnamon-complete \
		-t cinnamon \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Mate

live_mate: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-n mate \
		-t mate \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_mate_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n mate-complete \
		-t mate \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# LXDE

live_lxde: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-n lxde \
		-t lxde \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_lxde_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-n lxde-complete \
		-t lxde \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Server 

live_server: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools \
		-n server \
		-t standard \
		-c error-prompt,golang,gists,tmux-conf


lives: \
	live_gnome_complete\
	live_gnome \
	live_kde \
	live_kde_complete \
	live_xfce \
	live_xfce_complete \
	live_cinnamon \
	live_cinnamon_complete \
	live_mate\
	live_mate_complete\
	live_lxde\
	live_lxde_complete\
	live_server
	

# Live ISO building

live_iso_gnome_complete: live_gnome_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p gnome-complete

live_iso_gnome: live_gnome
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p gnome

live_iso_kde: live_kde
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p kde

live_iso_kde_complete: live_kde_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p kde-complete

live_iso_xfce: live_xfce
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p xfce

live_iso_xfce_complete: live_xfce_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p xfce-complete

live_iso_cinnamon: live_cinnamon
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p cinnamon

live_iso_cinnamon_complete: live_cinnamon_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p cinnamon-complete

live_iso_mate: live_mate
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p mate

live_iso_mate_complete: live_mate_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p mate-complete

live_iso_lxde: live_lxde
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p lxde

live_iso_lxde_complete: live_lxde_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p lxde-complete

live_iso_server: live_server
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p server

# Running live ISO

run_live_gnome_complete: live_iso_gnome_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/gnome-complete-live.iso

run_live_gnome: live_iso_gnome
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/gnome-live.iso

run_live_kde: live_iso_kde
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/kde-live.iso

run_live_kde_complete: live_iso_kde_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/kde-complete-live.iso

run_live_xfce: live_iso_xfce
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/xfce-live.iso

run_live_xfce_complete: live_iso_xfce_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/xfce-complete-live.iso

run_live_cinnamon: live_iso_cinnamon
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/cinnamon-live.iso

run_live_cinnamon_complete: live_iso_cinnamon_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/cinnamon-complete-live.iso

run_live_mate: live_iso_mate
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/mate-live.iso

run_live_mate_complete: live_iso_mate_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/mate-complete-live.iso

run_live_lxde: live_iso_lxde
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/lxde-live.iso

run_live_lxde_complete: live_iso_lxde_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/lxde-complete-live.iso

run_live_server: live_iso_server
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/server-live.iso

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