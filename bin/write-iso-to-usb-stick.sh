#!/usr/bin/env bash
set -e

while getopts "u:i:p" opt 
do
	case $opt in
		u)
			USB_STICK=$OPTARG
			;;
		i)
			ISO_IMAGE=$OPTARG
			;;
		p)
			PERSISTENCE=true
			;;
		?)
			echo Invalid opt -${OPTARG}
			;;
	esac
done

(echo $(basename ${0^^});
echo;
echo iso image: $ISO_IMAGE;
echo usb stick: $USB_STICK;
echo persistence: $PERSISTENCE;
)|boxes -d ada-box

(readlink -e /dev/disk/by-id/usb*|grep -w -q ${USB_STICK}) || exit 3

sudo sh -c "pv $ISO_IMAGE > $USB_STICK; sync"
if [ -n "$PERSISTENCE" ]; then
   MNT_TEMPDIR=$(mktemp -d)
   # create new partition and accept default three times
   sudo fdisk $USB_STICK<<EOF
n




w
EOF
   PERSISTENCE_PART=${USB_STICK}3
   sudo mkfs.ext4 -L persistence ${PERSISTENCE_PART}
   sudo mount ${PERSISTENCE_PART} $MNT_TEMPDIR
   sudo sh -c "echo /home >> $MNT_TEMPDIR/persistence.conf"
   sudo umount $MNT_TEMPDIR
fi
