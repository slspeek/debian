#!/usr/bin/env bash
set -e

KEEP=false

while getopts "s:p:d:k" opt 
do
	case $opt in
		s)
			STAGE_DIR=$OPTARG
			;;
		p)
			PROFILE_NAME=$OPTARG
			;;
    d)
			DESTINATION=$OPTARG
			;;
    k)
			KEEP=true
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
echo Destination: $DESTINATION;
echo Keep build directory: $KEEP;
)|boxes -d ada-box

function get_tag() {
  if git diff --exit-code &> /dev/null; then
    git describe
  else 
    echo UNCOMMITED
  fi
}

LIVE_PROFILE_NAME=${PROFILE_NAME}-live
mkdir -p $STAGE_DIR $DESTINATION
cd $STAGE_DIR 
tar xvzf ../build/${LIVE_PROFILE_NAME}.tar.gz
cd $LIVE_PROFILE_NAME
./build.sh
cd build
lb config --mirror-bootstrap http://mirrors.xtom.nl/debian/
sudo sh -c 'command time lb build 2>&1 | tee ../build.log'
mv live-image-amd64.hybrid.iso ${DESTINATION}/${LIVE_PROFILE_NAME}-$(get_tag).iso
cd ..
if [ "$KEEP" = "false" ]; 
then
  echo Cleaning up build directory ..
  sudo rm -rf build
fi