#!/usr/bin/env bash
# set -e

ENABLE_ROOT_LOGIN_OPT=false
ASK_FOR_USER=false

while getopts "aru:p:t:c:o:" opt 
do
	case $opt in
		a) 
			ASK_FOR_USER=true
			;;
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


(echo ask for user: $ASK_FOR_USER;
echo default user: $DEFAULT_USER;
echo enable root login: $ENABLE_ROOT_LOGIN_OPT;
echo packages: $PACKAGE_LISTS;
echo scripts: $LATE_CMDS;
echo tasks: $TASKS;
echo output file: $OUT_FILE)|boxes -d ada-box

PACKAGE_TMPFILE=$(mktemp)

for PACKAGE_LIST in ${PACKAGE_LISTS//,/ }
do 
    cat package-lists/$PACKAGE_LIST  >> $PACKAGE_TMPFILE || exit 4
done

SCRIPTS_TMPFILE=$(mktemp)

COMMAND="LATE_CMD_LOGGING_DIR=$LATE_CMD_LOGGING_DIR LATE_CMD_SRC=/usr/local/bin/late-cmds.sh /usr/local/bin/late-cmd-helper.sh ${LATE_CMDS//,/ }"

echo "    in-target /bin/sh -c '"$COMMAND ">" "$LATE_CMD_LOGGING_DIR/late-cmd.log 2>&1'" "&& \\"   >> $SCRIPTS_TMPFILE


if test "$ENABLE_ROOT_LOGIN_OPT" = "true"
then
	ROOT_LOGIN="$(cat preseed.cfg.d/root-login)"
else
	ROOT_LOGIN="$(cat preseed.cfg.d/no-root-login)"
fi

if test "$ASK_FOR_USER" = "true"
then
	USER_CONFIG="# let the installer ask for the username"
else
	USER_CONFIG="$(cat preseed.cfg.d/user-config)"
fi

export PRESEED_NAME=$(basename $OUT_FILE)
export GIT_HASH=$(git rev-parse --verify HEAD)
export GIT_DATE=$(git show --no-patch --no-notes --pretty='%cd' $(git rev-parse --verify HEAD))
export ENABLE_ROOT_LOGIN_OPT
export PACKAGE_LISTS
export USER_CONFIG
export ROOT_LOGIN
export DEFAULT_USER
export DEFAULT_USER_FULLNAME=${DEFAULT_USER^}
export CMDS="$(cat $SCRIPTS_TMPFILE)"
export PACKAGES="$(cat $PACKAGE_TMPFILE|sort -u| sed  -e 's/\(.*\)/        \1 \\/g'|sed -e '$ s/\\//')"
export TASKS="$(cat tasks/$TASKS|tr '\n' ',')"
export LATE_CMDS
export ASK_FOR_USER
export LATE_CMD_LOGGING_DIR

envsubst < preseed.cfg > build/preseed.cfg.1

envsubst < build/preseed.cfg.1 > $OUT_FILE

rm build/preseed.cfg.1