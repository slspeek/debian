
SHELL=/bin/bash

clean:
	rm -rf build

prepare: check_file_endings
	mkdir -p build

.ONESHELL:
preseed: prepare
	export PACKAGES="$(shell cat package-lists/{essential-commandline-tools,commandline-tools,desktop,dutch-desktop,docker})"
	export TASKS="$(shell cat tasks/gnome|tr '\n' ',')"
	envsubst < preseed.cfg > build/preseed.cfg

.ONESHELL:
check_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		echo -n $${FILE} " ";test $$(tail -c 1 $${FILE} | wc -l) -eq 1; if test "$$?" -eq "0"; then echo OK; else echo No newline at the end of the file; fi
	done
	