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

if [ -n "$PERSISTENCE" ]; then
  echo Persistence set
else
  echo No Persistence
fi

# TODO: tempdir for /mnt
sudo sh -c "pv $ISO_IMAGE > $USB_STICK; sync"
if [ -n "$PERSISTENCE" ]; then
   # TODO: parted
   sudo mkfs.ext4 -L persistence ${USB_STICK}2
   sudo mount ${USB_STICK}2 /mnt
   sudo sh -c 'echo "/home" >> /mnt/persistence.conf'
   sudo umount /mnt
fi
