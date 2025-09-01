#!/usr/bin/env bash
set -e

while getopts "i:" opt 
do
	case $opt in
		i)
			LIVE_ISO_PATH=$OPTARG
			;;
		?)
			echo Invalid opt -${OPTARG}
			;;
	esac
done

(echo $(basename ${0^^});
echo;
echo Live iso path: $LIVE_ISO_PATH;
)|boxes -d ada-box

LIVE_ISO=$(basename $LIVE_ISO_PATH)
PROFILE_NAME=${LIVE_ISO//.iso}
VM_NAME=${PROFILE_NAME}-test

virt-install \
        --name $VM_NAME \
        --osinfo debian11 \
        --video virtio \
        --cdrom $LIVE_ISO_PATH \
        --memory 3048 \
        --vcpu 2
virsh destroy $VM_NAME
virsh undefine $VM_NAME