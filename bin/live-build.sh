#!/usr/bin/env bash
set -e

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


(echo $(basename ${0^^});
echo;
echo ask for user: $ASK_FOR_USER;
echo default user: $DEFAULT_USER;
echo enable root login: $ENABLE_ROOT_LOGIN_OPT;
echo packages: $PACKAGE_LISTS;
echo scripts: $LATE_CMDS;
echo tasks: $TASKS;
echo output file: $OUT_FILE)|boxes -d ada-box


export PRESEED_NAME=$(basename $OUT_FILE)
export GIT_HASH=$(git rev-parse --verify HEAD)
export GIT_DATE=$(git show --no-patch --no-notes --pretty='%cd' $(git rev-parse --verify HEAD))
export ENABLE_ROOT_LOGIN_OPT
export PACKAGE_LISTS
export USER_CONFIG
export ROOT_LOGIN
export DEFAULT_USER
export DEFAULT_USER_FULLNAME=${DEFAULT_USER^}
export PACKAGES="$(merge-packages.sh $PACKAGE_LISTS|sed  -e 's/\(.*\)/        \1 \\/g'|sed -e '$ s/\\//')"
export TASKS="$(cat tasks/$TASKS|grep -v 'standard')"
export LATE_CMDS
export LATE_CMD_STANZA="$(late-cmd-constructor.sh $LATE_CMDS $LATE_CMD_LOGGING_DIR $PRESEED_NAME)"
export ASK_FOR_USER
export LATE_CMD_LOGGING_DIR

LIVE_BUILD_NAME=live-build-${PRESEED_NAME/.*/}

STAGE_AREA=$(mktemp -d)/$LIVE_BUILD_NAME

mkdir $STAGE_AREA

LIVE_BUILD_SCRIPT=$STAGE_AREA/$LIVE_BUILD_NAME.sh

cat >  $LIVE_BUILD_SCRIPT <<EOF
set -e
sudo rm -rfv  $LIVE_BUILD_NAME|| exit 0
mkdir $LIVE_BUILD_NAME
cd $LIVE_BUILD_NAME
lb config --distribution bookworm --parent-archive-areas "main contrib non-free non-free-firmware" --bootappend-live "boot=live components locales=nl_NL.UTF-8 "
cp ../packages.lst config/package-lists/live.list.chroot
cp ../tasks.packages.lst  config/package-lists/tasks.list.chroot
cp ../late-cmds.hook.chroot config/hooks/live
time sudo lb build
EOF

chmod +x $LIVE_BUILD_SCRIPT

merge-packages.sh $PACKAGE_LISTS > $STAGE_AREA/packages.lst 

echo $TASKS|sed -E 's/^./task-&/' > $STAGE_AREA/tasks.packages.lst

late-cmd-constructor.sh $LATE_CMDS $LATE_CMD_LOGGING_DIR $PRESEED_NAME > $STAGE_AREA/late-cmds.hook.chroot

pushd $STAGE_AREA/..
tar czf $STAGE_AREA/../${LIVE_BUILD_NAME}.tar.gz  $(basename $STAGE_AREA)
popd
mv $STAGE_AREA/../${LIVE_BUILD_NAME}.tar.gz build/${LIVE_BUILD_NAME}.tar.gz