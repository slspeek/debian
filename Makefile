
SHELL=/bin/bash

clean:
	rm -rf build
prepare:
	mkdir -p build

.ONESHELL:
preseed: prepare
	export PACKAGES="$(shell cat package-lists/{essential-commandline-tools,commandline-tools,desktop,dutch-desktop,docker})"
	export TASKS="$(shell cat tasks/gnome|tr '\n' ',')"
	envsubst < preseed.cfg > build/preseed.cfg
