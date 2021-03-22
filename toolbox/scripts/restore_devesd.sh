#!/bin/sh
# Info
export TOPIC=devesd
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will restore GreenMenus"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

# Restore file(s) to unit
if [ -f /tsd/etc/persistence/esd/Power.esd ]; then
	rm -rv /tsd/etc/persistence/esd/*
	. /tsd/etc/persistence/esd/scripts/util_restore.sh
else
	echo "No developer GreenMenu installed. Aborting"
	exit 0
fi

echo
echo "Done. Now restart the GreenMenu"

exit 0
