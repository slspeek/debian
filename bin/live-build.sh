#!/usr/bin/env bash
set -e

ENABLE_ROOT_LOGIN_OPT=false

while getopts "ru:p:t:n:c:o:" opt 
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
        n)
            PROFILE_NAME=$OPTARG
            ;;
		?)
			echo Invalid opt -${OPTARG}
			;;
	esac
done


(echo $(basename ${0^^});
echo;
echo profile name: $PROFILE_NAME;
echo default user: $DEFAULT_USER;
echo enable root login: $ENABLE_ROOT_LOGIN_OPT;
echo packages: $PACKAGE_LISTS;
echo scripts: $LATE_CMDS;
echo tasks: $TASKS;
)|boxes -d ada-box

DEFAULT_USER_FULLNAME=${DEFAULT_USER^}
export TASKS="$(cat tasks/$TASKS|grep -v 'standard')"
LIVE_BUILD_NAME=${PROFILE_NAME}-live

STAGE_AREA=$(mktemp -d)/$LIVE_BUILD_NAME

mkdir $STAGE_AREA

LIVE_BUILD_SCRIPT=$STAGE_AREA/build.sh

mkdir $STAGE_AREA/auto

TEMP_CONFIG=$(mktemp)

cat >  $TEMP_CONFIG <<'EOF'
lb config noauto \
		--distribution bookworm \
		--parent-archive-areas "main contrib non-free non-free-firmware" \
		--bootappend-live "boot=live components locales=nl_NL.UTF-8 username=${DEFAULT_USER} \
							user-fullname=${DEFAULT_USER_FULLNAME}" \
		"$@"
EOF
export DEFAULT_USER
export DEFAULT_USER_FULLMANE
envsubst '$DEFAULT_USER $DEFAULT_USER_FULLMANE'< $TEMP_CONFIG > $STAGE_AREA/auto/config
chmod +x $STAGE_AREA/auto/config

cat >  $LIVE_BUILD_SCRIPT <<EOF
set -e

sudo rm -rfv  build|| exit 0
mkdir build
cd build
mkdir -p config/{package-lists,hooks}
mkdir -p config/hooks/live
cp ../packages.lst config/package-lists/${LIVE_BUILD_NAME}.list.chroot
cp ../tasks.packages.lst  config/package-lists/${LIVE_BUILD_NAME}-tasks.list.chroot
cp ../late-cmds.hook.chroot config/hooks/live
cp -r ../includes.chroot config 
cp -r ../auto .
mkdir -p config/includes.chroot/etc/skel/.config && echo yes > config/includes.chroot/etc/skel/.config/gnome-initial-setup-done
mkdir -p config/includes.chroot/etc/live/config.conf.d/
echo "LIVE_USER_DEFAULT_GROUPS=\"audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker\"" > config/includes.chroot/etc/live/config.conf.d/10-user-setup.conf
EOF

chmod +x $LIVE_BUILD_SCRIPT

cp -rv resource/live/includes.chroot $STAGE_AREA

merge-packages.sh $PACKAGE_LISTS > $STAGE_AREA/packages.lst 

echo $TASKS|sed -E 's/^./task-&/' > $STAGE_AREA/tasks.packages.lst

late-cmd-constructor.sh $LATE_CMDS $LATE_CMD_LOGGING_DIR ${PROFILE_NAME}.cfg > $STAGE_AREA/late-cmds.hook.chroot

pushd $STAGE_AREA/..
tar czf $STAGE_AREA/../${LIVE_BUILD_NAME}.tar.gz  $(basename $STAGE_AREA)
popd
mv $STAGE_AREA/../${LIVE_BUILD_NAME}.tar.gz build/${LIVE_BUILD_NAME}.tar.gz