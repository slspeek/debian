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

PRESEED_CREATION_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) create-preseed-configuration.sh
LIVE_BUILD_CMD=LATE_CMD_LOGGING_DIR=$(LATE_CMD_LOGGING_DIR) live-build.sh
LIVE_STAGE_DIR=$(shell pwd)/live-isos
LIVE_ISO_DESTINATION=$(LIVE_STAGE_DIR)
LIVE_ISO_KEEP=
DEFAULT_USER=$(shell cat default-user)

default: clean all

all: precommit scripts preseeds validate_preseeds lives website

preseeds: \
	gnome\
	gnome_personal\
	gnome_complete\
	gnome_complete_personal\
	cursus\
	tutor\
	steven\
	kde\
	kde_personal\
	kde_complete\
	kde_complete_personal\
	xfce\
	xfce_personal\
	xfce_complete\
	xfce_complete_personal\
	cinnamon\
	cinnamon_personal\
	cinnamon_complete\
	cinnamon_complete_personal\
	mate\
	mate_personal\
	mate_complete\
	mate_complete_personal\
	lxde\
	lxde_personal\
	lxde_complete\
	lxde_complete_personal\
	multi\
	multi_personal\
	multi_complete\
	multi_complete_personal\
	server\
	server_personal

clean:
	rm -rf build

clean_isos:
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
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/gnome.cfg \
		-t gnome \
		-c $(MINIMAL_LATE_CMDS),shortcuts

gnome_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/gnome-personal.cfg \
		-t gnome \
		-c $(MINIMAL_LATE_CMDS),shortcuts

gnome_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/gnome-complete.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS),shortcuts

gnome_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/gnome-complete-personal.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS)

cursus: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,desktop,dutch-desktop \
		-o build/cursus.cfg \
		-t gnome \
		-c prepare-education-box,error-prompt,short-grub-timeout,tmux-conf,no-gnome-initial

tutor: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,cli-tools,desktop,developer-cli,docker,dutch-desktop,video-editing \
		-o build/tutor.cfg \
		-t gnome \
		-c error-prompt,gists,prepare-education-box,tmux-conf,no-gnome-initial,short-grub-timeout,vscode,docker

steven: prepare
	$(PRESEED_CREATION_CMD) \
		-r \
		-u steven \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/steven.cfg \
		-t gnome \
		-c $(COMPLETE_LATE_CMDS),shortcuts

# KDE

kde: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/kde.cfg \
		-t kde \
		-c $(MINIMAL_LATE_CMDS)

kde_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/kde-personal.cfg \
		-t kde \
		-c  $(MINIMAL_LATE_CMDS)

kde_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/kde-complete.cfg \
		-t kde \
		-c $(COMPLETE_LATE_CMDS)

kde_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/kde-complete-personal.cfg \
		-t kde \
		-c $(COMPLETE_LATE_CMDS)

# XFCE

xfce: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/xfce.cfg \
		-t xfce \
		-c $(MINIMAL_LATE_CMDS)

xfce_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/xfce-personal.cfg \
		-t xfce \
		-c  $(MINIMAL_LATE_CMDS)

xfce_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/xfce-complete.cfg \
		-t xfce \
		-c $(COMPLETE_LATE_CMDS)

xfce_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/xfce-complete-personal.cfg \
		-t xfce \
		-c $(COMPLETE_LATE_CMDS)


# Cinnamon

cinnamon: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/cinnamon.cfg \
		-t cinnamon \
		-c $(MINIMAL_LATE_CMDS)

cinnamon_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/cinnamon-personal.cfg \
		-t cinnamon \
		-c  $(MINIMAL_LATE_CMDS)

cinnamon_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/cinnamon-complete.cfg \
		-t cinnamon \
		-c $(COMPLETE_LATE_CMDS)

cinnamon_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/cinnamon-complete-personal.cfg \
		-t cinnamon \
		-c $(COMPLETE_LATE_CMDS)

# Mate

mate: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/mate.cfg \
		-t mate \
		-c $(MINIMAL_LATE_CMDS)

mate_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-o build/mate-personal.cfg \
		-t mate \
		-c  $(MINIMAL_LATE_CMDS)

mate_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/mate-complete.cfg \
		-t mate \
		-c $(COMPLETE_LATE_CMDS)

mate_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/mate-complete-personal.cfg \
		-t mate \
		-c $(COMPLETE_LATE_CMDS)

# LXDE

lxde: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),upgrades \
 		-o build/lxde.cfg \
		-t lxde \
		-c $(MINIMAL_LATE_CMDS),uu-add-origins,uu-activate

lxde_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS),upgrades \
		-o build/lxde-personal.cfg \
		-t lxde -c $(MINIMAL_LATE_CMDS),uu-add-origins,uu-activate

lxde_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/lxde-complete.cfg \
		-t lxde \
		-c $(COMPLETE_LATE_CMDS)

lxde_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS),upgrades \
		-o build/lxde-complete-personal.cfg \
		-t lxde -c $(COMPLETE_LATE_CMDS),uu-add-origins,uu-activate

# Multi desktop environment	

multi: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/multi.cfg \
		-t multi \
		-c $(MINIMAL_LATE_CMDS),shortcuts

multi_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		-o build/multi-personal.cfg \
		-t multi \
		-c $(MINIMAL_LATE_CMDS),shortcuts

multi_complete: prepare
	$(PRESEED_CREATION_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/multi-complete.cfg \
		-t multi \
		-c $(COMPLETE_LATE_CMDS),shortcuts

multi_complete_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-a \
		-p $(ALL_PACKAGE_LISTS) \
		-o build/multi-complete-personal.cfg \
		-t multi \
		-c $(COMPLETE_LATE_CMDS)

# Server

server: prepare
	$(PRESEED_CREATION_CMD) -r \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools,cli-tools,developer-cli,docker,server \
		-o build/server.cfg \
		-t standard \
		-c error-prompt,short-grub-timeout,sudo-nopasswd,tmux-conf,docker

server_personal: prepare
	$(PRESEED_CREATION_CMD) \
		-r \
		-a \
		-p essential-cli-tools,cli-tools,developer-cli,docker,server \
		-o build/server-personal.cfg \
		-t standard \
		-c error-prompt,short-grub-timeout,sudo-nopasswd,tmux-conf,docker

# Live configuration generation
DEFAULT_LIVE_COMPONENTS=-l components

# GNOME

live_gnome_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n gnome-complete \
		-t gnome \
		-c $(COMPLETE_LIVE_LATE_CMDS)

live_gnome: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS),gnome-extensions \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n gnome \
		-t gnome \
		-c $(MINIMAL_LIVE_LATE_CMDS)

# KDE

live_kde: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n kde \
		-t kde \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_kde_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n kde-complete \
		-t kde \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# XFCE

live_xfce: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n xfce \
		-t xfce \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_xfce_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n xfce-complete \
		-t xfce \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Cinnamon

live_cinnamon: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n cinnamon \
		-t cinnamon \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_cinnamon_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n cinnamon-complete \
		-t cinnamon \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Mate

live_mate: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n mate \
		-t mate \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_mate_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n mate-complete \
		-t mate \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# LXDE

live_lxde: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n lxde \
		-t lxde \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_lxde_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		$(DEFAULT_LIVE_COMPONENTS) \
		-i \
		-n lxde-complete \
		-t lxde \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# multi

live_multi: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(MINIMAL_PACKAGE_LISTS) \
		-l nocomponents=gdm3 \
		-n multi \
		-t multi \
		-c $(MINIMAL_LIVE_LATE_CMDS)

live_multi_complete: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p $(ALL_PACKAGE_LISTS) \
		-l nocomponents=gdm3 \
		-n multi-complete \
		-t multi \
		-c $(COMPLETE_LIVE_LATE_CMDS)

# Server 

live_server: prepare
	$(LIVE_BUILD_CMD) \
		-u $(DEFAULT_USER) \
		-p essential-cli-tools \
		$(DEFAULT_LIVE_COMPONENTS) \
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
	live_multi\
	live_multi_complete\
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

live_iso_multi: live_multi
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p multi

live_iso_multi_complete: live_multi_complete
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p multi-complete

live_iso_server: live_server
	create-live-iso.sh -d $(LIVE_ISO_DESTINATION) -s $(LIVE_STAGE_DIR) $(LIVE_ISO_KEEP) -p server

live_isos: \
	live_iso_gnome \
	live_iso_kde \
	live_iso_xfce \
	live_iso_cinnamon \
	live_iso_mate \
	live_iso_lxde \
	live_iso_multi \
	live_iso_server

live_modern_complete_isos: \
	live_iso_gnome_complete \
	live_iso_kde_complete \
	live_iso_cinnamon_complete \
	live_iso_multi_complete 

live_complete_isos: \
	live_modern_complete_isos \
	live_iso_xfce_complete \
	live_iso_mate_complete \
	live_iso_lxde_complete 

live_isos_all: \
	live_isos \
	live_complete_isos

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

run_live_multi: live_iso_multi
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/multi-live.iso

run_live_multi_complete: live_iso_multi_complete
	test-live-iso.sh -i $(LIVE_ISO_DESTINATION)/multi-complete-live.iso

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
