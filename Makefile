
SHELL=/bin/bash

clean:
	rm -rf build

prepare: check_file_endings
	mkdir -p build

.ONESHELL:
scripts: prepare
	cd scripts
	tar czf ../build/scripts.tar.gz *.sh

.ONESHELL:
preseed: prepare scripts
	./interpolate-preseed.sh -p essential-cli-tools,cli-tools,desktop,dutch-desktop,docker -o build/preseed.cfg -t gnome

.ONESHELL:
check_file_endings:
	@for FILE in $(shell ls package-lists/*)
	do
		echo -n $${FILE} " ";test $$(tail -c 1 $${FILE} | wc -l) -eq 1; if test "$$?" -eq "0"; then echo OK; else echo No newline at the end of the file; fi
	done
	