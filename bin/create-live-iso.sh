#!/usr/bin/env bash
set -e

while getopts "s:p:" opt 
do
	case $opt in
		s)
			STAGE_DIR=$OPTARG
			;;
		p)
			PROFILE_NAME=$OPTARG
			;;
		?)
			echo Invalid opt -${OPTARG}
			;;
	esac
done

(echo $(basename ${0^^});
echo;
echo Profile name: $PROFILE_NAME;
echo Stage directory: $STAGE_DIR;
)|boxes -d ada-box

LIVE_PROFILE_NAME=${PROFILE_NAME}-live
mkdir -p $STAGE_DIR && \
cd $STAGE_DIR && \
tar xvzf ../build/${LIVE_PROFILE_NAME}.tar.gz && \
cd $LIVE_PROFILE_NAME && \
./build.sh && \
cd build && \
lb config --mirror-bootstrap http://mirrors.xtom.nl/debian/ && \
time sudo lb build
mv live-image-amd64.hybrid.iso ${LIVE_PROFILE_NAME}.iso
