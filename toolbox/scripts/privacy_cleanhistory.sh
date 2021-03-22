#!/bin/sh
# Coded by Jille for MIB2 High Toolbox
# Modified by Olli for MIB2STD Toolbox
# Info
DESCRIPTION="This script will remove all update logs from your SWDL menu"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # for later

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

# Deleting
LOGPATH=/tsd/var/swdownload/swdlhistory

if [ -f $LOGPATH/swdownload1.conf ]; then
	echo "Deleting SWDL history"
	rm -r -f $LOGPATH/*
	sleep 1
	echo "Done. Your updates are now no longer visible"
else
	echo "SWDL history is already clean"
fi

exit 0
