#!/bin/bash
#

while getopts ":p:t:s:o:" opt 
do
	case $opt in
		p)
			PACKAGE_LISTS=$OPTARG
			;;
		s)
			SCRIPTS=$OPTARG
			;;
		t)
			TASKS=$OPTARG
			;;
        o)
            OUT_FILE=$OPTARG
            ;;
		?)
			echo Invalid opt -${OPTARG}
			;;
	esac
done

echo packages: $PACKAGE_LISTS
echo scripts: $SCRIPTS
echo tasks: $TASKS
echo output file: $OUT_FILE

PACKAGE_TMPFILE=$(mktemp)

for PACKAGE_LIST in ${PACKAGE_LISTS//,/ }
do 
    cat package-lists/$PACKAGE_LIST | tr '\n' ' ' >> $PACKAGE_TMPFILE
done

export PACKAGES="$(cat $PACKAGE_TMPFILE)"
export TASKS="$(cat tasks/$TASKS|tr '\n' ',')"
envsubst < preseed.cfg > $OUT_FILE