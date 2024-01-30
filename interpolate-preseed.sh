#!/bin/bash
#
ENABLE_ROOT_LOGIN_OPT=false

while getopts "ru:p:t:c:o:" opt 
do
	case $opt in
		r)
			ENABLE_ROOT_LOGIN_OPT=true
			;;
		u)
			DEFAULT_USER=$OPTARG
			;;
		p)
			PACKAGE_LISTS=$OPTARG
			;;
		c)
			LATE_CMDS=$OPTARG
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


(echo enable root login: $ENABLE_ROOT_LOGIN_OPT;
echo packages: $PACKAGE_LISTS;
echo scripts: $LATE_CMDS;
echo tasks: $TASKS;
echo output file: $OUT_FILE)|boxes -d ada-box

PACKAGE_TMPFILE=$(mktemp)

for PACKAGE_LIST in ${PACKAGE_LISTS//,/ }
do 
    cat package-lists/$PACKAGE_LIST | tr '\n' ' ' >> $PACKAGE_TMPFILE
done

SCRIPTS_TMPFILE=$(mktemp)

for CMD in ${LATE_CMDS//,/ }
do 
	while read LINE
	do
		echo "    in-target $LINE && \\"   >> $SCRIPTS_TMPFILE
	done < late-cmds/$CMD
done

if test "$ENABLE_ROOT_LOGIN_OPT" = "true"
then
	ROOT_LOGIN="$(cat preseed.cfg.d/root-login)"
else
	ROOT_LOGIN="$(cat preseed.cfg.d/no-root-login)"
fi
export ROOT_LOGIN
export DEFAULT_USER
export DEFAULT_USER_FULLNAME=${DEFAULT_USER^}
export CMDS="$(cat $SCRIPTS_TMPFILE)"
export PACKAGES="$(cat $PACKAGE_TMPFILE)"
export TASKS="$(cat tasks/$TASKS|tr '\n' ',')"

envsubst < preseed.cfg > build/preseed.cfg.1

envsubst < build/preseed.cfg.1 > $OUT_FILE

rm build/preseed.cfg.1