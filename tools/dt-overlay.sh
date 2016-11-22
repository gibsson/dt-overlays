#!/bin/sh

set -e

OVERLAYS=/sys/kernel/config/device-tree/overlays
FIRMWARE=/lib/firmware

function add()
{
	if [ -e $OVERLAYS/$1 ]; then
		echo Overlay $1 already exists
		exit -1
	fi

	mkdir $OVERLAYS/$1
	echo $(basename $FIRMWARE/*$1*) > $OVERLAYS/$i/path
}

function remove()
{
	rmdir $OVERLAYS/$1
}

cmd=add

mnt=`mount`
if ! [[ "$mnt" == *"configfs"* ]] ; then
	mount -t configfs none /sys/kernel/config
fi

for i in $*; do
	case $i in
		add)
			cmd=add
			;;
		rm)
			cmd=remove
			;;
		*)
			$cmd $i
			;;
	esac
done
